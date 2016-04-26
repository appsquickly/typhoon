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

- (void)injectPropertiesForViewController:(UIViewController *)viewController withFactory:(id<TyphoonComponentFactory>)factory;

@end
