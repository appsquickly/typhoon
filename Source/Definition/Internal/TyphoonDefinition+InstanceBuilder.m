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
#import "TyphoonPropertyInjectedWithStringRepresentation.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonInitializer+InstanceBuilder.h"

@implementation TyphoonDefinition (InstanceBuilder)



/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (NSString*)factoryReference
{
    return _factoryReference;
}

- (void)setFactoryReference:(NSString*)factoryReference;
{
    _factoryReference = factoryReference;
}

- (NSSet*)componentsInjectedByValue;
{
    NSMutableSet* set = [[NSMutableSet alloc] init];
    [set unionSet:[self propertiesInjectedByValue]];

    NSArray* a = [self.initializer parametersInjectedByValue];
    [set unionSet:[NSSet setWithArray:a]];
    return set;
}

- (void)injectProperty:(SEL)selector withReference:(NSString*)reference
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByReference alloc]
            initWithName:NSStringFromSelector(selector) reference:reference]];
}

- (void)injectProperty:(SEL)selector withReference:(NSString*)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByReference alloc]
            initWithName:NSStringFromSelector(selector) reference:reference fromCollaboratingAssemblyProxy:fromCollaboratingAssemblyProxy]];
}

- (NSSet*)propertiesInjectedByValue
{
    return [self injectedPropertiesWithKind:[TyphoonPropertyInjectedWithStringRepresentation class]];
}

- (NSSet*)propertiesInjectedByType
{
    return [self injectedPropertiesWithKind:[TyphoonPropertyInjectedByType class]];
}

- (NSSet*)propertiesInjectedByReference
{
    return [self injectedPropertiesWithKind:[TyphoonPropertyInjectedByReference class]];
}

- (void)addInjectedProperty:(id <TyphoonInjectedProperty>)property
{
    [_injectedProperties addObject:property];
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSSet*)injectedPropertiesWithKind:(Class)clazz
{
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings)
    {
        return [evaluatedObject isKindOfClass:clazz];
    }];
    return [_injectedProperties filteredSetUsingPredicate:predicate];
}

@end
