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
#import <UIKit/UIKit.h>

@implementation StoryboardViewControllerAssembly

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

@end
