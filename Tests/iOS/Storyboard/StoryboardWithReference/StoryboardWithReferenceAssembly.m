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
#import "StoryboardMainViewController.h"
#import "StoryboardDetailViewController.h"

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

- (StoryboardMainViewController *)storyboardMainViewController
{
    return [TyphoonDefinition withClass:[StoryboardMainViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(model) with:[self model]];
    }];
}

- (StoryboardDetailViewController *)storyboardDetailViewController
{
    return [TyphoonDefinition withClass:[StoryboardDetailViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(model) with:[self model]];
    }];
}

- (UIStoryboard *)storyboardWithReference {
    return [TyphoonDefinition withClass:[TyphoonStoryboard class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(storyboardWithName:factory:bundle:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@"StoryboardWithReference"];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:[NSBundle bundleForClass:[self class]]];
        }];
    }];
}
@end
