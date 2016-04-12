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


#import "TyphoonAssembly.h"

@class StoryboardFirstViewController;

@interface StoryboardViewControllerAssembly : TyphoonAssembly

- (StoryboardFirstViewController *)initialViewController;

- (UIViewController *)firstViewController;

- (UIViewController *)secondViewController;

- (UIViewController *)uniqueViewController;

- (UIViewController *)singletonViewController;

- (UIViewController *)lazySingletonViewController;

- (UIViewController *)weakSingletonViewController;

- (UIViewController *)prototypeViewController;

- (UIStoryboard *)storyboard;

- (UIViewController *)oneMoreViewControllerWithId:(NSString *)controllerId title:(NSString *)title;

@end
