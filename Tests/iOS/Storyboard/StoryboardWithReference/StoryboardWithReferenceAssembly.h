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

@interface StoryboardWithReferenceAssembly : TyphoonAssembly

- (StoryboardTabBarFirstViewController *)storyboardTabBarFirstViewController;
- (StoryboardTabBarSecondViewController *)storyboardTabBarSecondViewController;

@end
