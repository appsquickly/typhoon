//
//  SingletonsChainAssembly.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 09/08/13.
//
//

#import "SingletonsChainAssembly.h"
#import "Typhoon.h"

#import "SingletonA.h"
#import "SingletonB.h"
#import "NotSingletonA.h"

@implementation SingletonsChainAssembly

- (id)singletonA
{
    return [TyphoonDefinition withClass:[SingletonA class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(dependencyOnB) withDefinition:[self singletonB]];
        [definition setScope:TyphoonScopeSingleton];
    }];
}

- (id)singletonB
{
    return [TyphoonDefinition withClass:[SingletonB class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(dependencyOnNotSingletonA) withDefinition:[self notSingletonA]];
        [definition setScope:TyphoonScopeSingleton];
    }];
}

- (id)notSingletonA
{
    return [TyphoonDefinition withClass:[NotSingletonA class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithSingletonA:);
        [initializer injectWithDefinition:[self singletonA]];
    }];
}

@end
