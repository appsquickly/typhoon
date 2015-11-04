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

/**
 * A collection of helper methods for type conversion purposes
 */
@interface TyphoonTypeConversionUtils : NSObject

/**
 * Returns the type from the text, e.g. NSURL for NSURL(http://typhoonframework.org)
 */
+ (NSString *)typeFromTextValue:(NSString *)textValue;

/**
 * Returns the type from the text, e.g. http://typhoonframework.org for NSURL(http://typhoonframework.org)
 */
+ (NSString *)textWithoutTypeFromTextValue:(NSString *)textValue;

@end
