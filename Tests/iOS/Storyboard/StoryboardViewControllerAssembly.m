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

#import "StoryboardViewControllerAssembly.h"
#import "Typhoon.h"
#import "UniqueViewController.h"
#import "StoryboardFirstViewController.h"
#import "StoryboardFirstViewController.h"
#import "TyphoonStoryboard.h"
#import <UIKit/UIKit.h>

@implementation StoryboardViewControllerAssembly

- (UIStoryboard *)storyboard {
    return [TyphoonDefinition withClass:[TyphoonStoryboard class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(storyboardWithName:factory:bundle:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@"Storyboard"];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:[NSBundle bundleForClass:[self class]]];
        }];
    }];
}

- (StoryboardFirstViewController *)initialViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(title) with:@"Initial"];
        }];
}


- (UIViewController *)firstViewController
{
    return [TyphoonDefinition withClass:[StoryboardFirstViewController class]
        configuration:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(title) with:@"First"];
            [definition injectProperty:@selector(dependency) with:[self dependency]];
        }];
}

- (StoryboardControllerDependency *)dependency
{
    return [TyphoonDefinition withClass:[StoryboardControllerDependency class]
        configuration:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(circularDependencyBackToViewController)
                with:[self firstViewController]];
        }];
}

- (UIViewController *)secondViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Second"];
    }];
}

- (UIViewController *)uniqueViewController
{
    return [TyphoonDefinition withClass:[UniqueViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Unique"];
    }];
}

- (UIViewController *)singletonViewController
{
    return [TyphoonDefinition withStoryboard:[self storyboard] viewControllerId:@"SingletonViewController" configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"singleton"];
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (UIViewController *)lazySingletonViewController
{
    return [TyphoonDefinition withStoryboard:[self storyboard] viewControllerId:@"SingletonViewController" configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"lazysingleton"];
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (UIViewController *)weakSingletonViewController
{
    return [TyphoonDefinition withStoryboard:[self storyboard] viewControllerId:@"SingletonViewController" configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"weaksingleton"];
        definition.scope = TyphoonScopeWeakSingleton;
    }];
}

- (UIViewController *)prototypeViewController
{
    return [TyphoonDefinition withStoryboard:[self storyboard] viewControllerId:@"PrototypeViewController" configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopePrototype;
    }];
}

- (UIViewController *)oneMoreViewController
{
    return [TyphoonDefinition withStoryboardName:@"Storyboard"
                                viewControllerId:@"OneMoreViewController"
                                   configuration:^(TyphoonDefinition *definition) {
                                    [definition injectProperty:@selector(title) with:@"OneMoreViewController"];
                                    definition.scope = TyphoonScopeSingleton;
                                }];
}

- (UIViewController *)oneMoreViewControllerWithId:(NSString *)controllerId title:(NSString *)title {
    return [TyphoonDefinition withStoryboardName:@"Storyboard"
                                viewControllerId:controllerId
                                   configuration:^(TyphoonDefinition *definition) {
                                       [definition injectProperty:@selector(title) with:title];
                                   }];
}

@end
