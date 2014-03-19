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

#import "ComponentFactoryAwareAssembly.h"
#import <TyphoonDefinition.h>
#import "ComponentFactoryAwareObject.h"
#import "Typhoon.h"

@implementation ComponentFactoryAwareAssembly

- (id)injectionAwareObject;
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class]];
}

- (id)injectionByProperty
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(componentFactory) with:self];
    }];
}

- (id)injectionByInitialization
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] injections:^(TyphoonDefinition *definition) {
        [definition injectInitializer:@selector(initWithComponentFactory) withParameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self];
        }];
    }];
}

- (id)injectionByPropertyAssemblyType
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(assembly)];
    }];
}

- (id)injectionByPropertyFactoryType
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(componentFactory)];
    }];
}


@end
