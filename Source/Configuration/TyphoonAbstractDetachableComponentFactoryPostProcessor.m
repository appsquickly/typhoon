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

- (void)rollback
{
    NSMutableArray *postProcessors = (NSMutableArray *) _factory.definitionPostProcessors;
    if (![postProcessors.lastObject isEqual:self]) {
        [NSException raise:@"Only the last TyphoonAbstractDetachableComponentFactoryPostProcessor can be rolled-back"
            format:@"%@",NSInternalInconsistencyException];
    }
    [postProcessors removeLastObject];
    _factory.registry = _rollbackDefinitions;
    [_factory unload];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)cacheDefinitionsIn:(TyphoonComponentFactory *)factory
{
    NSMutableArray *definitions = [[NSMutableArray alloc] init];
    for (TyphoonDefinition *definition in factory.registry) {
        [definitions addObject:[definition copy]];
    }
    _rollbackDefinitions = [definitions mutableCopy];
}


@end