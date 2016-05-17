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

#ifdef __IPHONE_2_0



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TyphoonComponentFactory.h"


/**
 * TyphoonNibLoader will inject properties for view controller.
 *
 * TyphoonNibLoader injection performed by view controller's type.
 */
@interface TyphoonViewControllerInitializer : NSObject

@property (nonatomic, strong) id<TyphoonComponentFactory> factory;

+ (TyphoonViewControllerInitializer *)viewControllerInitializer;

+ (TyphoonViewControllerInitializer *)viewControllerInitializerWithFactory:(id<TyphoonComponentFactory>)factory;

/**
 Instantiates and returns the view controller.
 
 View controller class will be the same as the class by NSClassFromString(className).
 Default class is UIViewController if NSClassFromString(className) is nil.
 @param className The view controller class name.
 @return The view controller created by init.
 */
- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)className;

@end

#endif
