////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@class TyphoonStoryboardDefinitionContext;
@class TyphoonComponentFactory;
@class TyphoonStoryboard;
@class TyphoonInjectionContext;

@interface TyphoonViewControllerFactory : NSObject

+ (UIViewController *)viewControllerWithStoryboardContext:(TyphoonStoryboardDefinitionContext *)context injectionContext:(TyphoonInjectionContext *)injectionContext factory:(TyphoonComponentFactory *)factory;
+ (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier storyboard:(TyphoonStoryboard *)storyboard;
+ (UIViewController *)cachedViewControllerWithIdentifier:(NSString *)identifier storyboardName:(NSString *)storyboardName factory:(TyphoonComponentFactory *)factory;


@end
