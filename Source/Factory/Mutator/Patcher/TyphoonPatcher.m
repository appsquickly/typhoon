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

#import "TyphoonDefinition.h"
#import "TyphoonPatcher.h"
#import "TyphoonPatchObjectFactory.h"
#import "TyphoonInitializer.h"
#import "OCLogTemplate.h"
#import "TyphoonDefinition+InstanceBuilder.h"


@implementation TyphoonPatcher

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self)
    {
        _patches = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)patchDefinitionWithKey:(NSString*)key withObject:(objectCreationBlock)objectCreationBlock
{
    id object = objectCreationBlock();
    [_patches setObject:object forKey:key];
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (NSArray*)newDefinitionsToRegister
{
    NSMutableArray* newDefinitions = [[NSMutableArray alloc] init];
    for (NSString* key in [_patches allKeys])
    {
        TyphoonDefinition* patchFactory =
            [[TyphoonDefinition alloc] initWithClass:[TyphoonPatchObjectFactory class] key:[self patchFactoryNameForKey:key]];
        patchFactory.initializer = [[TyphoonInitializer alloc] initWithSelector:@selector(initWithObject:)];
        [patchFactory.initializer injectWithObject:[_patches objectForKey:key]];
        [newDefinitions addObject:patchFactory];
    }
    LogDebug(@"New definitions to register: %@", newDefinitions);
    return [newDefinitions copy];
}

- (void)mutateComponentDefinitionsIfRequired:(NSArray*)componentDefinitions
{
    for (TyphoonDefinition* definition in componentDefinitions)
    {
        id patchObject = [_patches objectForKey:definition.key];
        if (patchObject)
        {
            LogDebug(@"Patching component with key %@ with object %@", definition.key, patchObject);
            [definition setFactoryReference:[self patchFactoryNameForKey:definition.key]];
            [definition setInitializer:[[TyphoonInitializer alloc] initWithSelector:@selector(object)]];
            [definition setInjectedProperties:nil];
        }
    }
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSString*)patchFactoryNameForKey:(NSString*)key
{
    return [NSString stringWithFormat:@"%@$$$patcher", key];
}


@end