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

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactory.h"

@interface TyphoonViewControllerInjector : NSObject

/**
 * Inject properties.
 *
 @param viewController View controller.
 @param factory Typhoon factory.
 */
- (void)injectPropertiesForViewController:(UIViewController *)viewController withFactory:(id<TyphoonComponentFactory>)factory;

/**
 *  * Inject properties and check view controller's storyboard is equal to param storyboard.
 *
 @param viewController View controller.
 @param factory Typhoon factory.
 @param storyboard Storyboard to compare with.
 */
- (void)injectPropertiesForViewController:(UIViewController *)viewController withFactory:(id<TyphoonComponentFactory>)factory storyboard:(UIStoryboard *)storyboard;

@end
