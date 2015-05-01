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
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+Infrastructure.h"

@implementation TyphoonComponentFactory (DetachableComponentFactoryPostProcessor)

- (void)setRegistry:(NSMutableArray *)registry
{
    _registry = registry;
}

@end


@implementation TyphoonAbstractDetachableComponentFactoryPostProcessor

- (void)postProcessDefinitionsInFactory:(TyphoonComponentFactory *)factory
{
    _factory = factory;
    [self cacheDefinitionsIn:_factory];
}

- (void)postProcessDefinition:(TyphoonDefinition *)definition withFactory:(TyphoonComponentFactory *)factory
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

- (void)cacheDefinitionsIn:(TyphoonComponentFactory *)factory
{
    NSMutableDictionary *definitions = [NSMutableDictionary new];
    for (TyphoonDefinition *definition in factory.registry) {
        definitions[[definition key]] = [definition copy];
    }
    _rollbackDefinitions = definitions;
}

- (void)cacheDefinition:(TyphoonDefinition *)definition
{
    _rollbackDefinitions[[definition key]] = [definition copy];
}


@end