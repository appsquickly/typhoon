////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonDefinition_Infrastructure)

#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonDefinition+Internal.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonMethod.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonReferenceDefinition.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonParameterInjection.h"
#import "TyphoonPropertyInjection.h"
#import "TyphoonInjectionByRuntimeArgument.h"

@implementation TyphoonDefinition (Infrastructure)

@dynamic key;
@dynamic initializer;
@dynamic initializerGenerated;

#pragma mark - Instance Methods

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByClass) {
        BOOL isSameClass = self.type == clazz;
        BOOL isSubclass = includeSubclasses && [self.type isSubclassOfClass:clazz];
        result = isSameClass || isSubclass;
    }
    return result;
}

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByProtocol) {
        result = [self.type conformsToProtocol:aProtocol];
    }
    return result;
}

- (TyphoonMethod *)beforeInjections
{
    if (!self.parent || _beforeInjections) {
        return _beforeInjections;
    }
    
    return [self.parent beforeInjections];
}

- (TyphoonMethod *)afterInjections
{
    if (!self.parent || _afterInjections) {
        return _afterInjections;
    }
    
    return [self.parent afterInjections];
}

- (NSSet *)injectedProperties
{
    if (!self.parent) {
        return [_injectedProperties mutableCopy];
    }

    NSMutableSet *properties = (NSMutableSet *)[self.parent injectedProperties];

    NSMutableSet *overriddenProperties = [NSMutableSet set];

    for (id<TyphoonPropertyInjection> parentProperty in properties) {
        for (id <TyphoonPropertyInjection> childProperty in _injectedProperties) {
            if ([[childProperty propertyName] isEqualToString:[parentProperty propertyName]]) {
                [overriddenProperties addObject:parentProperty];
            }
        }
    }

    [properties minusSet:overriddenProperties];
    [properties unionSet:_injectedProperties];

    return properties;
}

- (NSOrderedSet *)injectedMethods
{
    if (!self.parent) {
        return [_injectedMethods mutableCopy];
    }
    NSMutableOrderedSet *methods = (NSMutableOrderedSet *)[self.parent injectedMethods];

    NSMutableSet *overriddenMethods = [NSMutableSet set];
    for (TyphoonMethod *parentMethod in methods) {
        for (TyphoonMethod *childMethod in _injectedMethods) {
            if (parentMethod.selector == childMethod.selector) {
                [overriddenMethods addObject:parentMethod];
            }
        }
    }

    [methods minusSet:overriddenMethods];
    [methods unionOrderedSet:_injectedMethods];

    return methods;
}

#pragma mark - Shorthands

- (void)addInjectedProperty:(id <TyphoonPropertyInjection>)property
{
    [_injectedProperties addObject:property];
}

- (void)addInjectedPropertyIfNotExists:(id <TyphoonPropertyInjection>)property
{
    BOOL isExists = NO;
    for (id<TyphoonPropertyInjection>p in _injectedProperties) {
        if ([[p propertyName] isEqualToString:[property propertyName]]) {
            isExists = YES;
            break;
        }
    }
    if (!isExists) {
        [_injectedProperties addObject:property];
    }
}

- (BOOL)hasRuntimeArgumentInjections
{
    __block BOOL hasInjections = NO;
    [self enumerateInjectionsOfKind:[TyphoonInjectionByRuntimeArgument class] options:TyphoonInjectionsEnumerationOptionAll
                         usingBlock:^(id injection, id *injectionToReplace, BOOL *stop) {
        hasInjections = YES;
        *stop = YES;
    }];
    return hasInjections;
}

#pragma mark - Enumeration

- (void)enumerateInjectionsOfKind:(Class)injectionClass options:(TyphoonInjectionsEnumerationOption)options
                       usingBlock:(TyphoonInjectionsEnumerationBlock)block
{
    if (options & TyphoonInjectionsEnumerationOptionMethods) {
        [self enumerateInjectionsOfKind:injectionClass onCollection:[self.initializer injectedParameters] withBlock:block
                           replaceBlock:^(id injection, id injectionToReplace) {
            [self.initializer replaceInjection:injection with:injectionToReplace];

        }];

        for (TyphoonMethod *method in [self injectedMethods]) {
            [self enumerateInjectionsOfKind:injectionClass onCollection:[method injectedParameters] withBlock:block
                               replaceBlock:^(id injection, id injectionToReplace) {
                [method replaceInjection:injection with:injectionToReplace];
            }];
        }
        
        [self enumerateInjectionsOfKind:injectionClass onCollection:[_afterInjections injectedParameters] withBlock:block replaceBlock:^(id injection, id injectionToReplace) {
            [self->_afterInjections replaceInjection:injection with:injectionToReplace];
        }];
        [self enumerateInjectionsOfKind:injectionClass onCollection:[_beforeInjections injectedParameters] withBlock:block replaceBlock:^(id injection, id injectionToReplace) {
            [self->_beforeInjections replaceInjection:injection with:injectionToReplace];
        }];
    }

    if (options & TyphoonInjectionsEnumerationOptionProperties) {
        [self enumerateInjectionsOfKind:injectionClass onCollection:[self injectedProperties] withBlock:block
                           replaceBlock:^(id injection, id injectionToReplace) {
            [self replacePropertyInjection:injection with:injectionToReplace];
        }];
    }
}

- (void)enumerateInjectionsOfKind:(Class)injectionClass onCollection:(id<NSFastEnumeration>)collection withBlock:(TyphoonInjectionsEnumerationBlock)block
                     replaceBlock:(void(^)(id injection, id injectionToReplace))replaceBlock
{
    for (id<TyphoonInjection>injection in collection) {
        if ([injection isKindOfClass:injectionClass]) {
            id injectionToReplace = nil;
            BOOL stop = NO;
            block(injection, &injectionToReplace, &stop);
            if (injectionToReplace) {
                replaceBlock(injection, injectionToReplace);
            }
            if (stop) {
                break;
            }
        }
    }
}

- (void)replacePropertyInjection:(id<TyphoonPropertyInjection>)injection with:(id<TyphoonPropertyInjection>)injectionToReplace
{
    if ([_injectedProperties containsObject:injection]) {
        [injectionToReplace setPropertyName:[injection propertyName]];
        [_injectedProperties removeObject:injection];
        [_injectedProperties addObject:injectionToReplace];
    } else if (self.parent) {
        [self.parent replacePropertyInjection:injection with:injectionToReplace];
    }
}

@end
