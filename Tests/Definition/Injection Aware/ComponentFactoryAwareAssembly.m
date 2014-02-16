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
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] properties:^(TyphoonDefinition *definition) {
        [definition injectPropertyWithComponentFactory:@selector(componentFactory)];
    }];
}

- (id)injectionByInitialization
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithComponentFactory);
        [initializer injectWithComponentFactory];
    }];
}

- (id)injectionByPropertyAssemblyType
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(assembly)];
    }];
}

- (id)injectionByPropertyFactoryType
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(componentFactory)];
    }];
}


@end
