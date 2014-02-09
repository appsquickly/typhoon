////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class TyphoonTypeDescriptor;

/**
* Declares a contract for converting configuration arguments to their required runtime type.
*/
@protocol TyphoonTypeConverter <NSObject>

/**
 The supported type of the converter. Class or protocol.
 */
- (id)supportedType;

/**
 Converts the given string into the supported type.
 */
- (id)convert:(NSString *)stringValue;

@end
