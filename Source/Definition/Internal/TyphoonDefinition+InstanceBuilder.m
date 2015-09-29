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

TYPHOON_LINK_CATEGORY(TyphoonDefinition_InstanceBuilder)

#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonMethod+InstanceBuilder.h"

#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonRuntimeArguments.h"

@implementation TyphoonDefinition (InstanceBuilder)

#pragma mark - Base methods

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

- (TyphoonMethod *)beforeInjections
{
    return _beforeInjections;
}

- (TyphoonMethod *)afterInjections
{
    return _afterInjections;
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

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return _type;
}

- (BOOL)matchesAutoInjectionByProtocol:(Protocol *)aProtocol
{
    return NO;
}

- (BOOL)matchesAutoInjectionByClass:(Class)aClass
{
    return NO;
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

@end
