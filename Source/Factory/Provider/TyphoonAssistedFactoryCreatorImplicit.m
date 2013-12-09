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

@implementation TyphoonAssistedFactoryCreatorImplicit
{
@private
    SEL _factoryMethod;
    SEL _initMethod;

    NSArray *_factoryMethodParameters;
    NSArray *_initMethodParameters;
    NSArray *_procotolPropertyNames;

    Class _returnType;
}

- (instancetype)initWithProtocol:(Protocol *)protocol returns:(Class)returnType
{
    return [super initWithProtocol:protocol factoryDefinitionProvider:^{
        _returnType = returnType;

        SEL factoryMethod = [self factoryMethod];
        NSArray *factoryMethodParameters = [self factoryMethodParameters];

        SEL initMethod = [self initializerMethod];
        NSArray *initMethodParameters = [self initializerMethodParameters];

        // Simple arrays will suffice... but being "maps from this to that", I
        // find dictionaries more semantic.
        NSDictionary *argumentParameters = [self findMappingsFrom:initMethodParameters to:factoryMethodParameters except:nil];

        NSArray *protocolPropertyNames = [self protocolPropertyNames];
        NSDictionary *propertyParameters = [self findMappingsFrom:initMethodParameters to:protocolPropertyNames except:factoryMethodParameters];

        TyphoonAssistedFactoryDefinition *factoryDefinition = [[TyphoonAssistedFactoryDefinition alloc] init];
        [factoryDefinition factoryMethod:factoryMethod returns:returnType initialization:^(TyphoonAssistedFactoryMethodInitializer *initializer) {
            initializer.selector = initMethod;

            [propertyParameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterName, NSString *propertyName, BOOL *stop) {
                [initializer injectParameterNamed:parameterName withProperty:sel_getUid([propertyName UTF8String])];
            }];

            [argumentParameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterName, NSString *argumentName, BOOL *stop) {
                [initializer injectParameterNamed:parameterName withArgumentNamed:argumentName];
            }];
        }];

        return factoryDefinition;
    }];
}

- (SEL)factoryMethod
{
    if (_factoryMethod == NULL)
    {
        _factoryMethod = TyphoonAssistedFactoryCreatorGuessFactoryMethodForProtocol(_protocol);
    }

    return _factoryMethod;
}

- (SEL)initializerMethod
{
    if (_initMethod == NULL)
    {
        // find candidates: methods in _returnType that starts with init.
        // for each:
        //   calculate number of argument parameters
        //   calculate number of property parameters
        //   if init has all parameters covered:
        //     calculate weight = [number argument parameters, number property parameters]
        //     compare with previous candidate, swap if better

        SEL bestCandidate = NULL;
        NSUInteger bestCandidateScore1 = 0; // argument parameters score
        NSUInteger bestCandidateScore2 = 0; // property parameters score
        NSSet *factoryMethodParameters = [NSSet setWithArray:[self factoryMethodParameters]];
        NSSet *protocolPropertyNames = [NSSet setWithArray:[self protocolPropertyNames]];

        unsigned int count = 0;
        Method *methods = class_copyMethodList(_returnType, &count);
        for (unsigned int idx = 0; idx < count; idx++)
        {
            Method method = methods[idx];
            SEL methodSEL = method_getName(method);
            NSString *methodName = [NSString stringWithUTF8String:sel_getName(methodSEL)];
            if ([methodName hasPrefix:@"initWith"])
            {
                NSArray *initParameters = [self parameterNamesForSelector:methodSEL];

                NSMutableSet *commonArguments = [NSMutableSet setWithArray:initParameters];
                [commonArguments intersectSet:factoryMethodParameters];

                NSMutableSet *commonProperties = [NSMutableSet setWithArray:initParameters];
                [commonProperties intersectSet:protocolPropertyNames];

                NSSet *coveredInitParameters = [commonArguments setByAddingObjectsFromSet:commonProperties];
                // we have to take out self and _cmd
                unsigned int numberOfArguments = method_getNumberOfArguments(method) - 2;
                if (coveredInitParameters.count >= numberOfArguments)
                {
                    if (bestCandidateScore1 < commonArguments.count ||
                        (bestCandidateScore1 == commonArguments.count &&
                         bestCandidateScore2 < commonProperties.count))
                    {
                        bestCandidate = methodSEL;
                        bestCandidateScore1 = commonArguments.count;
                        bestCandidateScore2 = commonProperties.count;
                    }
                }
            }
        }
        free(methods);

        NSAssert(bestCandidate != NULL,
                 @"Could not find suitable candidate init for [%s %s] in %s",
                 protocol_getName(_protocol),
                 sel_getName([self factoryMethod]),
                 class_getName(_returnType));
        _initMethod = bestCandidate;
        LogTrace(@"Factory Provider: found candidate: [%s %s] --> [%s %s]",
                 protocol_getName(_protocol),
                 sel_getName([self factoryMethod]),
                 class_getName(_returnType),
                 sel_getName(_initMethod));
    }

    return _initMethod;
}

- (NSArray *)factoryMethodParameters
{
    if (_factoryMethodParameters == nil)
    {
        _factoryMethodParameters = [self parameterNamesForSelector:[self factoryMethod]];
    }

    return _factoryMethodParameters;
}

- (NSArray *)initializerMethodParameters
{
    if (_initMethodParameters == nil)
    {
        _initMethodParameters = [self parameterNamesForSelector:[self initializerMethod]];
    }

    return _initMethodParameters;
}

- (NSArray *)protocolPropertyNames
{
    if (_procotolPropertyNames == nil)
    {
        unsigned int count= 0;
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
        if ([toNames containsObject:name] && ![exceptNamesOrNil containsObject:name])
        {
            mappings[name] = name;
        }
    }

    return mappings;
}

@end
