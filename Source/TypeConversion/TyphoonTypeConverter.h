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
#import "TyphoonTypeConverterRegistry.h"


/**
* Declares a contract for converting configuration arguments to their required runtime type.
*/
@protocol TyphoonTypeConverter <NSObject>

/**
 The supported type of the converter. Class or protocol.
 */
- (NSString *)supportedType;

/**
 Converts the given string into the supported type.
 */
- (id)convert:(NSString *)stringValue;

@end

