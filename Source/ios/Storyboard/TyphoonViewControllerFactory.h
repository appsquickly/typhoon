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
@protocol TyphoonComponentFactory;
@class TyphoonStoryboard;
@class TyphoonInjectionContext;

@interface TyphoonViewControllerFactory : NSObject

+ (UIViewController *)viewControllerWithStoryboardContext:(TyphoonStoryboardDefinitionContext *)context injectionContext:(TyphoonInjectionContext *)injectionContext factory:(id<TyphoonComponentFactory>)factory;
+ (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier storyboard:(TyphoonStoryboard *)storyboard;
+ (UIViewController *)cachedViewControllerWithIdentifier:(NSString *)identifier storyboardName:(NSString *)storyboardName factory:(id<TyphoonComponentFactory>)factory;


@end
