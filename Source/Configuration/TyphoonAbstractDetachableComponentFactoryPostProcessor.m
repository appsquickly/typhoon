////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
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

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    _factory = factory;
    [self cacheDefinitionsIn:_factory];
}

- (void)rollback
{
    NSMutableArray *postProcessors = (NSMutableArray *) _factory.factoryPostProcessors;
    if (![postProcessors.lastObject isEqual:self]) {
        [NSException raise:@"Only the last TyphoonAbstractDetachableComponentFactoryPostProcessor can be rolled-back"
            format:@"%@",NSInternalInconsistencyException];
    }
    [postProcessors removeLastObject];
    _factory.registry = _rollbackDefinitions;
    [_factory unload];
}

/* ====================================================================================================================================== */
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