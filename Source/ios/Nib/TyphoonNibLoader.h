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
 * TyphoonNibLoader will inject properties for each viewController instantiated with nib name.
 *
 * TyphoonNibLoader injection performed by viewController's type.
 */
@interface TyphoonNibLoader : NSObject

@property (nonatomic, strong) id<TyphoonComponentFactory> factory;
@property (nonatomic, strong) NSBundle *bundle;

+ (TyphoonNibLoader *)nibLoaderWithBundle:(NSBundle *)bundleOrNil;

+ (TyphoonNibLoader *)nibLoaderWithFactory:(id<TyphoonComponentFactory>)factory bundle:(NSBundle *)bundleOrNil;

/**
 Instantiates and returns the view controller with the specified nib name.
 
 View controller class will be the same as the class by NSClassFromString(nibName).
 Default class is UIViewController if NSClassFromString(nibName) is nil.
 @param nibName The nib name.
 @return The view controller created by initWithNibName:bundle:.
 */
- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)nibName;

@end

#endif
