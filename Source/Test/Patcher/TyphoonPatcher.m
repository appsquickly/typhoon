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
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonRuntimeArguments.h"

@interface TyphoonPatcherDefinition : TyphoonDefinition

@property (nonatomic, strong) TyphoonPatchObjectCreationBlock patchObjectBlock;

- (id)initWithOriginalDefinition:(TyphoonDefinition *)definition patchObjectBlock:(TyphoonPatchObjectCreationBlock)patchObjectBlock;

@end

@implementation TyphoonPatcherDefinition

- (id)initWithOriginalDefinition:(TyphoonDefinition *)definition patchObjectBlock:(TyphoonPatchObjectCreationBlock)patchObjectBlock
{
    self = [super initWithClass:definition.type key:definition.key];
    if (self) {
        self.patchObjectBlock = patchObjectBlock;
        self.scope = definition.scope;
        self.autoInjectionVisibility = definition.autoInjectionVisibility;

    }
    return self;
}

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return self.patchObjectBlock();
}

- (id)initializer
{
    return nil;
}

@end


@implementation TyphoonPatcher {
    NSMutableDictionary *_patches;
    NSMutableDictionary *_originals;
    id<TyphoonDefinitionPostProcessorInvalidator> _invalidator;
    BOOL _isDetaching;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        _patches = [NSMutableDictionary new];
        _originals = [NSMutableDictionary new];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods

- (void)patchDefinitionWithKey:(NSString *)key withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock
{
    [self patchDefinitionWithSelector:NSSelectorFromString(key) withObject:objectCreationBlock];
}

- (void)patchDefinition:(TyphoonDefinition *)definition withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock
{
    [self patchDefinitionWithSelector:NSSelectorFromString(definition.key) withObject:objectCreationBlock];
}

- (void)patchDefinitionWithSelector:(SEL)definitionSelector withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock
{
    [_patches setObject:objectCreationBlock forKey:NSStringFromSelector(definitionSelector)];
}

- (void)detach
{
    [_invalidator invalidatePostProcessor:self];
    _isDetaching = YES;
    [_invalidator forcePostProcessing];
    [_invalidator removePostProcessor:self];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Protocol Methods

- (void)postProcessDefinition:(TyphoonDefinition *)definition replacement:(TyphoonDefinition **)definitionToReplace
{
    if (!_isDetaching) {
        TyphoonPatchObjectCreationBlock patchObjectBlock = _patches[definition.key];
        if (patchObjectBlock) {
            *definitionToReplace = [[TyphoonPatcherDefinition alloc] initWithOriginalDefinition:definition patchObjectBlock:patchObjectBlock];
            _originals[definition.key] = definition;
        }
    } else {
        TyphoonDefinition *originalDefinition = _originals[definition.key];
        if (originalDefinition) {
            *definitionToReplace = originalDefinition;
        }
    }
}

- (void)setPostProcessorInvalidator:(id<TyphoonDefinitionPostProcessorInvalidator>)invalidator
{
    _invalidator = invalidator;
}


@end