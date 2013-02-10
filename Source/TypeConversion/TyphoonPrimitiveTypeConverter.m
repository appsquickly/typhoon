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


#import "TyphoonPrimitiveTypeConverter.h"


@implementation TyphoonPrimitiveTypeConverter


/* ========================================================== Interface Methods ========================================================= */

- (int)convertToInt:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    int converted = 0;
    [scanner scanInt:&converted];
    return converted;
}

- (short)convertToShort:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    int converted = 0;
    [scanner scanInt:&converted];
    return [[NSNumber numberWithInt:converted] shortValue];
}

- (long)convertToLong:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    long long converted = 0;
    [scanner scanLongLong:&converted];
    return [[NSNumber numberWithLongLong:converted] longValue];
}

- (long long)convertToLongLong:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    long long converted = 0;
    [scanner scanLongLong:&converted];
    return converted;
}

- (unsigned char)convertToUnsignedChar:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    unsigned int converted = 0;
    [scanner scanInt:&converted];
    return (unsigned char) converted;
}

- (unsigned int)convertToUnsignedInt:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    int converted = 0;
    [scanner scanInt:&converted];
    return [[NSNumber numberWithInt:converted] unsignedIntValue];
}

- (unsigned short)convertToUnsignedShort:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    int converted = 0;
    [scanner scanInt:&converted];
    return [[NSNumber numberWithInt:converted] unsignedShortValue];
}

- (unsigned long)convertToUnsignedLong:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    long long converted = 0;
    [scanner scanLongLong:&converted];
    return [[NSNumber numberWithLong:converted] unsignedLongValue];
}

- (unsigned long long)convertToUnsignedLongLong:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    long long converted = 0;
    [scanner scanLongLong:&converted];
    return [[NSNumber numberWithLongLong:converted] unsignedLongValue];
}

- (float)convertToFloat:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    float converted = 0;
    [scanner scanFloat:&converted];
    return converted;
}

- (double)convertToDouble:(NSString*)stringValue
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    double converted = 0;
    [scanner scanDouble:&converted];
    return converted;
}

- (BOOL)convertToBoolean:(NSString*)stringValue
{
    return [stringValue boolValue];
}

- (const char*)convertToCString:(NSString*)stringValue
{
    return [stringValue cStringUsingEncoding:NSUTF8StringEncoding];
}

- (Class)convertToClass:(NSString*)stringValue
{
    return NSClassFromString(stringValue);
}

- (SEL)convertToSelector:(NSString*)stringValue
{
    return NSSelectorFromString(stringValue);
}

@end