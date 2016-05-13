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

#import "TyphoonAbstractDetachableComponentFactoryPostProcessor.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition+Infrastructure.h"

@implementation TyphoonComponentFactory (DetachableComponentFactoryPostProcessor)

- (void)setRegistry:(NSMutableArray *)registry
{
    _registry = registry;
}

@end


@implementation TyphoonAbstractDetachableComponentFactoryPostProcessor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rollbackDefinitions = [NSMutableDictionary new];
    }
    return self;
}

- (void)postProcessDefinition:(TyphoonDefinition *)definition replacement:(TyphoonDefinition **)definitionToReplace withFactory:(TyphoonComponentFactory *)factory
{
    _factory = factory;
    [self cacheDefinition:definition];
}

- (void)rollback
{
    NSMutableArray *postProcessors = (NSMutableArray *) _factory.definitionPostProcessors;
    if (![postProcessors.lastObject isEqual:self]) {
        [NSException raise:@"Only the last TyphoonAbstractDetachableComponentFactoryPostProcessor can be rolled-back"
            format:@"%@",NSInternalInconsistencyException];
    }
    [postProcessors removeLastObject];
    _factory.registry = [[_rollbackDefinitions allValues] mutableCopy];
    [_factory unload];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)cacheDefinition:(TyphoonDefinition *)definition
{
    if ([definition key]) {
        _rollbackDefinitions[[definition key]] = [definition copy];
    }
}


@end
