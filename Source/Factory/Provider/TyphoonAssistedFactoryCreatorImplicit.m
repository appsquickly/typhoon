////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonAssistedFactoryCreatorImplicit.h"
#import "TyphoonAssistedFactoryCreator+Private.h"

#include <objc/runtime.h>

#import "NSObject+TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"

static NSString *const kMethodKey = @"kMethodKey";
static NSString *const kScoreKey = @"kScoreKey";

@interface TyphoonAssistedFactoryCreatorImplicitMethod : NSObject
@property(nonatomic, assign) SEL methodName;
@property(nonatomic, copy) NSArray *methodParameterNames;
@end

@interface TyphoonAssistedFactoryCreatorImplicitFactoryMethod : TyphoonAssistedFactoryCreatorImplicitMethod
@property(nonatomic, copy) NSArray *preferredInitializers;
@property(nonatomic, strong) TyphoonAssistedFactoryCreatorImplicitMethod *selectedInitializer;
@end

@implementation TyphoonAssistedFactoryCreatorImplicit
{
@private
    NSArray *_procotolPropertyNames;

    Class _returnType;
}

- (instancetype)initWithProtocol:(Protocol *)protocol returns:(Class)returnType
{
    return [super initWithProtocol:protocol factoryDefinitionProvider:^{
        _returnType = returnType;

        NSArray *factoryMethods = [self protocolFactoryMethods];
        NSArray *initializerMethods = [self returnTypeInitializerMethods];

        for (id factoryMethod in factoryMethods) {
            [self calculatePreferredInitializersFor:factoryMethod withInitializers:initializerMethods];
        }

        [self matchFactoryMethods:factoryMethods withInitializers:initializerMethods];

        TyphoonAssistedFactoryDefinition *factoryDefinition = [[TyphoonAssistedFactoryDefinition alloc] init];
        for (TyphoonAssistedFactoryCreatorImplicitFactoryMethod *method in factoryMethods) {
            // Simple arrays will suffice... but being "maps from this to that", I
            // find dictionaries more semantic.
            NSDictionary *argumentParameters =
                [self findMappingsFrom:method.selectedInitializer.methodParameterNames to:method.methodParameterNames except:nil];
            NSDictionary *propertyParameters =
                [self findMappingsFrom:method.selectedInitializer.methodParameterNames to:[self protocolPropertyNames]
                    except:method.methodParameterNames];

            [factoryDefinition factoryMethod:method.methodName returns:returnType
                initialization:^(TyphoonAssistedFactoryMethodInitializer *initializer) {
                    initializer.selector = method.selectedInitializer.methodName;

                    [propertyParameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterName, NSString *propertyName, BOOL *stop) {
                        [initializer injectParameterNamed:parameterName withProperty:sel_getUid([propertyName UTF8String])];
                    }];

                    [argumentParameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterName, NSString *argumentName, BOOL *stop) {
                        [initializer injectParameterNamed:parameterName withArgumentNamed:argumentName];
                    }];
                }];
        }

        return factoryDefinition;
    }];
}

- (NSArray *)protocolFactoryMethods
{
    NSMutableSet *propertyNames = [NSMutableSet set];
    NSMutableSet *methodNames = [NSMutableSet set];

    TyphoonAssistedFactoryCreatorForEachMethodInProtocol(_protocol, ^(struct objc_method_description methodDescription) {
        [methodNames addObject:NSStringFromSelector(methodDescription.name)];
    });

    TyphoonAssistedFactoryCreatorForEachPropertyInProtocol(_protocol, ^(objc_property_t property) {
        [propertyNames addObject:[NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding]];
    });

    [methodNames minusSet:propertyNames];

    NSMutableArray *factoryMethods = [NSMutableArray arrayWithCapacity:methodNames.count];
    for (NSString *methodName in methodNames) {
        TyphoonAssistedFactoryCreatorImplicitFactoryMethod *method = [[TyphoonAssistedFactoryCreatorImplicitFactoryMethod alloc] init];
        method.methodName = NSSelectorFromString(methodName);
        method.methodParameterNames = [self parameterNamesForSelector:method.methodName];

        [factoryMethods addObject:method];
    }

    return [factoryMethods copy];
}

- (NSArray *)returnTypeInitializerMethods
{
    NSMutableArray *initializerMethods = [NSMutableArray array];
    TyphoonAssistedFactoryCreatorForEachMethodInClass(_returnType, ^(struct objc_method_description methodDescription) {
        if ([NSStringFromSelector(methodDescription.name) hasPrefix:@"initWith"]) {
            TyphoonAssistedFactoryCreatorImplicitMethod *method = [[TyphoonAssistedFactoryCreatorImplicitMethod alloc] init];
            method.methodName = methodDescription.name;
            method.methodParameterNames = [self parameterNamesForSelector:method.methodName];

            [initializerMethods addObject:method];
        }
    });

    return [initializerMethods copy];
}

- (void)calculatePreferredInitializersFor:(TyphoonAssistedFactoryCreatorImplicitFactoryMethod *)factoryMethod
    withInitializers:(NSArray *)initializerMethods
{
    NSSet *factoryMethodParameters = [NSSet setWithArray:factoryMethod.methodParameterNames];
    NSSet *protocolPropertyNames = [NSSet setWithArray:[self protocolPropertyNames]];

    NSMutableArray *preferredInitializers = [NSMutableArray array];
    for (TyphoonAssistedFactoryCreatorImplicitMethod *method in initializerMethods) {
        NSMutableSet *commonArguments = [NSMutableSet setWithArray:method.methodParameterNames];
        [commonArguments intersectSet:factoryMethodParameters];

        NSMutableSet *commonProperties = [NSMutableSet setWithArray:method.methodParameterNames];
        [commonProperties intersectSet:protocolPropertyNames];

        NSSet *coveredInitParameters = [commonArguments setByAddingObjectsFromSet:commonProperties];
        NSUInteger numberOfArguments = method.methodParameterNames.count;

        if (coveredInitParameters.count >= numberOfArguments) {
            // If you have more than 100 arguments in your initializer... better
            // go back to the drawing board.
            [preferredInitializers addObject:@{
                kMethodKey : method,
                kScoreKey : @(commonArguments.count * 100 + commonProperties.count)
            }];
        }
    }

    [preferredInitializers sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:kScoreKey ascending:NO]]];
    factoryMethod.preferredInitializers = preferredInitializers;
}

- (void)matchFactoryMethods:(NSArray *)factoryMethods withInitializers:(NSArray *)initializers
{
    // This method matches the factory method to the best initializer.
    // You can find all the information at http://en.wikipedia.org/wiki/Stable_marriage_problem
    // Basically, it goes like this:
    // - All factory methods and initializers start as free.
    // - While there are free factory methods
    //   - Select the preferred initializer for the first free method not yet selected
    //   - If that initializer if free, the factory method matches the initializer
    //   - If not free, but the factory method has highest score, the factory
    //     method matches the initializer, the old factory method becomes free.
    //   - Otherwise, keep looking.
    // At the end all the factory methods should be matched with the best
    // initializer (not all the initializers needs to be matched).

    NSRange factoryMethodRange = NSMakeRange(0, factoryMethods.count);
    NSMutableIndexSet *freeFactoryMethods = [NSMutableIndexSet indexSetWithIndexesInRange:factoryMethodRange];
    // A NSMapTable will make this easier, but it is only supported from 10.5/6.0
    NSMutableDictionary *initializerCandidates = [NSMutableDictionary dictionaryWithCapacity:initializers.count];
    NSMutableDictionary *initializerCandidatesInfo = [NSMutableDictionary dictionaryWithCapacity:initializers.count];

    NSMutableArray *factoryMethodsMaxProposalIndices = [NSMutableArray arrayWithCapacity:factoryMethods.count];
    for (NSUInteger idx = 0; idx < factoryMethods.count; idx++) {factoryMethodsMaxProposalIndices[idx] = @0;}

    while ([freeFactoryMethods intersectsIndexesInRange:factoryMethodRange]) {
        NSUInteger factoryMethodIndex = [freeFactoryMethods firstIndex];
        TyphoonAssistedFactoryCreatorImplicitFactoryMethod *factoryMethod = factoryMethods[factoryMethodIndex];
        NSNumber *factoryMethodMaxProposalIndex = factoryMethodsMaxProposalIndices[factoryMethodIndex];
        factoryMethodsMaxProposalIndices[factoryMethodIndex] = @([factoryMethodMaxProposalIndex unsignedIntegerValue] + 1);

        NSAssert([factoryMethodMaxProposalIndex unsignedIntegerValue] <
            factoryMethod.preferredInitializers.count, @"Could not find suitable candidate init for [%s %s] in %s", protocol_getName(_protocol), sel_getName(factoryMethod.methodName), class_getName(_returnType));

        NSDictionary *preferredInitializer = factoryMethod.preferredInitializers[[factoryMethodMaxProposalIndex unsignedIntegerValue]];
        TyphoonAssistedFactoryCreatorImplicitMethod *initializer = preferredInitializer[kMethodKey];
        NSUInteger initializerIndex = [initializers indexOfObject:initializer];
        NSNumber *candidateIndex = initializerCandidates[@(initializerIndex)];
        if (!candidateIndex) {
            initializerCandidates[@(initializerIndex)] = @(factoryMethodIndex);
            initializerCandidatesInfo[@(initializerIndex)] = preferredInitializer;
            [freeFactoryMethods removeIndex:factoryMethodIndex];
        }
        else {
            NSDictionary *previousPreferredInitializer = initializerCandidatesInfo[@(initializerIndex)];

            if ([preferredInitializer[kScoreKey] integerValue] > [previousPreferredInitializer[kScoreKey] integerValue]) {
                [freeFactoryMethods addIndex:[candidateIndex unsignedIntegerValue]];
                initializerCandidates[@(initializerIndex)] = @(factoryMethodIndex);
                initializerCandidatesInfo[@(initializerIndex)] = preferredInitializer;
                [freeFactoryMethods removeIndex:factoryMethodIndex];
            }
        }
    }

    for (NSNumber *initializerIndex in initializerCandidates) {
        NSNumber *factoryMethodIndex = initializerCandidates[initializerIndex];
        TyphoonAssistedFactoryCreatorImplicitMethod *initializer = initializers[[initializerIndex unsignedIntegerValue]];
        TyphoonAssistedFactoryCreatorImplicitFactoryMethod *factoryMethod = factoryMethods[[factoryMethodIndex unsignedIntegerValue]];

        LogTrace(@"Factory Provider: found candidate: [%s %s] --> [%s %s]", protocol_getName(_protocol), sel_getName(factoryMethod.methodName), class_getName(_returnType), sel_getName(initializer.methodName));

        factoryMethod.selectedInitializer = initializer;
    }
}

- (NSArray *)protocolPropertyNames
{
    if (_procotolPropertyNames == nil) {
        unsigned int count = 0;
        objc_property_t *properties = protocol_copyPropertyList(_protocol, &count);
        NSMutableArray *names = [NSMutableArray arrayWithCapacity:count];

        for (unsigned int idx = 0; idx < count; idx++) {
            [names addObject:[NSString stringWithUTF8String:property_getName(properties[idx])]];
        }
        free(properties);

        _procotolPropertyNames = [names copy];
    }

    return _procotolPropertyNames;
}

- (NSDictionary *)findMappingsFrom:(NSArray *)fromNames to:(NSArray *)toNames except:(NSArray *)exceptNamesOrNil
{
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    exceptNamesOrNil = exceptNamesOrNil ?: [NSArray array];

    for (NSString *name in fromNames) {
        if ([toNames containsObject:name] && ![exceptNamesOrNil containsObject:name]) {
            mappings[name] = name;
        }
    }

    return mappings;
}

@end

@implementation TyphoonAssistedFactoryCreatorImplicitMethod
@end

@implementation TyphoonAssistedFactoryCreatorImplicitFactoryMethod
@end

