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
#import <UIKit/UIKit.h>

@implementation StoryboardViewControllerAssembly

- (id)initialViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Initial"];
    }];
}

- (id)firstViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"First"];
    }];
}

- (id)secondViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Second"];
    }];
}

- (id)uniqueViewController
{
    return [TyphoonDefinition withClass:[UniqueViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Unique"];
    }];
}

@end
