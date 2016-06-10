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

- (StoryboardTabBarFirstViewController *)storyboardTabBarFirstViewController
{
    return [TyphoonDefinition withClass:[StoryboardTabBarFirstViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"TabBar First ViewController"];
        [definition injectProperty:@selector(model)];
    }];
}

- (StoryboardTabBarSecondViewController *)storyboardTabBarSecondViewController
{
    return [TyphoonDefinition withClass:[StoryboardTabBarSecondViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"TabBar Second ViewController"];
        [definition injectProperty:@selector(model)];
    }];
}

- (Model *)model
{
    return [TyphoonDefinition withClass:[Model class]];
}

@end
