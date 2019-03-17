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

#import "TyphoonAssembly.h"

@class StoryboardTabBarFirstViewController;
@class StoryboardTabBarSecondViewController;
@class StoryboardMainViewController;
@class StoryboardDetailViewController;
@class Model;

@interface StoryboardWithReferenceAssembly : TyphoonAssembly

- (Model *)model;
- (StoryboardTabBarFirstViewController *)storyboardTabBarFirstViewController;
- (StoryboardTabBarSecondViewController *)storyboardTabBarSecondViewController;
- (StoryboardMainViewController *)storyboardMainViewController;
- (StoryboardDetailViewController *)storyboardDetailViewController;
- (UIStoryboard *)storyboardWithReference;

@end
