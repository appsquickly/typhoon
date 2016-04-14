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
@class TyphoonInjectionContext;

@interface TyphoonViewControllerFactory : NSObject

+ (UIViewController *)viewControllerWithStoryboardContext:(TyphoonStoryboardDefinitionContext *)context injectionContext:(TyphoonInjectionContext *)injectionContext factory:(TyphoonComponentFactory *)factory;
+ (UIViewController *)viewControllerWithPrototype:(UIViewController *)prototype factory:(TyphoonComponentFactory *)factory;

@end
