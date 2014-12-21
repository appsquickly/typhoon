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

#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import "TyphoonDefinitionPostProcessor.h"

/**
* @ingroup Configuration
*
 Post-Processor that completes the initializer of definitions with type UIViewController.
 If the definition already has a TyphoonInitializer set, the processor will ignore the component.
 */
@interface TyphoonViewControllerNibResolver : NSObject <TyphoonDefinitionPostProcessor>

/**
 Resolves the nib name for a view controller class.
 Defaults to the same name as the class by NSStringFromClass.
 @param viewControllerClass The class.
 @return The nib name.
 */
- (NSString *)resolveNibNameForClass:(Class)viewControllerClass;

@end

