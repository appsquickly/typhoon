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
#import "TyphoonTypeConverter.h"

@class TyphoonTypeDescriptor;

@interface TyphoonPrimitiveTypeConverter : NSObject


- (int)convertToInt:(NSString *)stringValue;

- (short)convertToShort:(NSString *)stringValue;

- (long)convertToLong:(NSString *)stringValue;

- (long long)convertToLongLong:(NSString *)stringValue;

- (unsigned char)convertToUnsignedChar:(NSString *)stringValue;

- (unsigned int)convertToUnsignedInt:(NSString *)stringValue;

- (unsigned short)convertToUnsignedShort:(NSString *)stringValue;

- (unsigned long)convertToUnsignedLong:(NSString *)stringValue;

- (unsigned long long)convertToUnsignedLongLong:(NSString *)stringValue;

- (float)convertToFloat:(NSString *)stringValue;

- (double)convertToDouble:(NSString *)stringValue;

- (BOOL)convertToBoolean:(NSString *)stringValue;

- (const char *)convertToCString:(NSString *)stringValue;

- (Class)convertToClass:(NSString *)stringValue;

- (SEL)convertToSelector:(NSString *)stringValue;

/** @return NSNumber of NSValue from textValue */
- (id)valueFromText:(NSString *)textValue withType:(TyphoonTypeDescriptor *)typeDescription;

@end
