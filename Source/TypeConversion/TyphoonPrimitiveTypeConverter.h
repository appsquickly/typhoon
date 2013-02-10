////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "TyphonTypeConverter.h"


@interface TyphoonPrimitiveTypeConverter : NSObject


- (int)convertToInt:(NSString*)stringValue;

- (short)convertToShort:(NSString*)stringValue;

- (long)convertToLong:(NSString*)stringValue;

- (long long)convertToLongLong:(NSString*)stringValue;

- (unsigned char)convertToUnsignedChar:(NSString*)stringValue;

- (unsigned int)convertToUnsignedInt:(NSString*)stringValue;

- (unsigned short)convertToUnsignedShort:(NSString*)stringValue;

- (unsigned long)convertToUnsignedLong:(NSString*)stringValue;

- (unsigned long long)convertToUnsignedLongLong:(NSString*)stringValue;

- (float)convertToFloat:(NSString*)stringValue;

- (double)convertToDouble:(NSString*)stringValue;

- (BOOL)convertToBoolean:(NSString*)stringValue;

- (const char*)convertToCString:(NSString*)stringValue;

- (Class)convertToClass:(NSString*)stringValue;

- (SEL)convertToSelector:(NSString*)stringValue;

- (void)setPrimitiveArgumentFor:(NSInvocation*)invocation index:(NSUInteger)index textValue:(NSString*)textValue
        requiredType:(TyphoonTypeDescriptor*)requiredType;

@end