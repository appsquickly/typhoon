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

#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonDefinition_InstanceBuilder)

#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonMethod+InstanceBuilder.h"

#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByRuntimeArgument.h"

@implementation TyphoonDefinition (InstanceBuilder)



/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (void)setType:(Class)type
{
    _type = type;
}

- (NSSet *)componentsInjectedByValue;
{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    [set unionSet:[self propertiesInjectedByValue]];

    NSArray *a = [self.initializer parametersInjectedByValue];
    [set unionSet:[NSSet setWithArray:a]];
    return set;
}

- (NSSet *)propertiesInjectedByValue
{
    return [self injectedPropertiesWithKind:[TyphoonInjectionByObjectFromString class]];
}

- (NSSet *)propertiesInjectedByType
{
    return [self injectedPropertiesWithKind:[TyphoonInjectionByType class]];
}

- (NSSet *)propertiesInjectedByObjectInstance
{
    return [self injectedPropertiesWithKind:[TyphoonInjectionByObjectInstance class]];
}

- (NSSet *)propertiesInjectedByReference
{
    return [self injectedPropertiesWithKind:[TyphoonInjectionByReference class]];
}

- (NSSet *)propertiesInjectedByRuntimeArgument
{
    return [self injectedPropertiesWithKind:[TyphoonInjectionByRuntimeArgument class]];
}

- (void)addInjectedProperty:(id <TyphoonPropertyInjection>)property
{
    [_injectedProperties addObject:property];
}

- (void)removeInjectedProperty:(id <TyphoonPropertyInjection>)property
{
    [_injectedProperties removeObject:property];
}

- (NSSet *)injectedProperties
{
    NSMutableSet *parentProperties = [self.parent injectedProperties] ? [[self.parent injectedProperties] mutableCopy] : [NSMutableSet set];
    
    NSMutableArray *overriddenProperties = [NSMutableArray array];
    [parentProperties enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([_injectedProperties containsObject:obj]) {
            [overriddenProperties addObject:obj];
        }
    }];
    
    for (id <TyphoonPropertyInjection> overriddenProperty in overriddenProperties) {
        [parentProperties removeObject:overriddenProperty];
    }
    
    return [[parentProperties setByAddingObjectsFromSet:_injectedProperties] copy];
}

- (NSSet *)injectedMethods
{
    NSMutableSet *parentMethods = [self.parent injectedMethods] ? [[self.parent injectedMethods] mutableCopy] : [NSMutableSet set];
    
    NSMutableArray *overriddenMethods = [NSMutableArray array];
    [parentMethods enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([_injectedMethods containsObject:obj]) {
            [overriddenMethods addObject:obj];
        }
    }];
    
    for (TyphoonMethod *overriddenMethod in overriddenMethods) {
        [parentMethods removeObject:overriddenMethod];
    }
    
    return [[parentMethods setByAddingObjectsFromSet:_injectedMethods] copy];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSSet *)injectedPropertiesWithKind:(Class)clazz
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:clazz];
    }];
    return [_injectedProperties filteredSetUsingPredicate:predicate];
}

@end
