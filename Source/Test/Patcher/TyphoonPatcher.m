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
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition+Infrastructure.h"

@implementation TyphoonPatcher

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        _patches = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)patchDefinitionWithKey:(NSString *)key withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock
{
    [_patches setObject:objectCreationBlock forKey:key];
}

- (void)patchDefinition:(TyphoonDefinition *)definition withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock
{
    [self patchDefinitionWithKey:definition.key withObject:objectCreationBlock];
}

- (void)patchDefinitionWithSelector:(SEL)definitionSelector withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock
{
    [self patchDefinitionWithKey:NSStringFromSelector(definitionSelector) withObject:objectCreationBlock];
}

- (void)detach
{
    [self rollback];
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    [super postProcessComponentFactory:factory];
    for (TyphoonDefinition *definition in [factory registry]) {
        id patchObject = [_patches objectForKey:definition.key];
        if (patchObject) {
            NSString *patcherKey = [NSString stringWithFormat:@"%@%@", definition.key, @"$$$patcher"];
            TyphoonDefinition *patchFactory = [[TyphoonDefinition alloc] initWithClass:[TyphoonPatchObjectFactory class] key:patcherKey];
            patchFactory.initializer = [[TyphoonMethod alloc] initWithSelector:@selector(initWithCreationBlock:)];
            [patchFactory.initializer injectParameterWith:patchObject];
            [patchFactory setScope:definition.scope];

            [definition setFactory:patchFactory];
            [definition setInitializer:[[TyphoonMethod alloc] initWithSelector:@selector(patchObject)]];
            [definition setValue:nil forKey:@"injectedProperties"];

            [factory registerDefinition:patchFactory];
        }
    }
}


@end