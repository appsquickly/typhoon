////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "StoryboardWithReferenceAssembly.h"
#import "StoryboardTabBarFirstViewController.h"
#import "StoryboardTabBarSecondViewController.h"
#import "Model.h"

@implementation StoryboardWithReferenceAssembly

- (Model *)model
{
    return [TyphoonDefinition withClass:[Model class]];
}

- (StoryboardTabBarFirstViewController *)storyboardTabBarFirstViewController
{
    return [TyphoonDefinition withClass:[StoryboardTabBarFirstViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(model) with:[self model]];
    }];
}

- (StoryboardTabBarSecondViewController *)storyboardTabBarSecondViewController
{
    return [TyphoonDefinition withClass:[StoryboardTabBarSecondViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(model) with:[self model]];
    }];
}

@end
