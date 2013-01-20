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
#import "TyphoonTypeDescriptor.h"


@implementation TyphoonPrimitiveTypeConverter


- (void*)convert:(NSString*)stringValue requiredType:(TyphoonTypeDescriptor*)typeDescriptor
{
    NSLog(@"Converting value: %@", stringValue);
    [self checkSupportedTypes:typeDescriptor];
    if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeBoolean || typeDescriptor.primitiveType == TyphoonPrimitiveTypeChar)
    {
        return (void*) [stringValue boolValue];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeString)
    {
        return (void*) [stringValue cStringUsingEncoding:NSUTF8StringEncoding];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeSelector)
    {
        return (void*) NSSelectorFromString(stringValue);
    }
    return [self convertNumericTypes:stringValue typeDescriptor:typeDescriptor];
}


/* ============================================================ Private Methods ========================================================= */
- (void)checkSupportedTypes:(TyphoonTypeDescriptor*)typeDescriptor
{
    if (typeDescriptor.isArray)
    {
        [NSException raise:NSInvalidArgumentException format:@"Array type not yet supported"];
    }
    else if (typeDescriptor.isStructure)
    {
        [NSException raise:NSInvalidArgumentException format:@"Structure type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeClass)
    {
        [NSException raise:NSInvalidArgumentException format:@"Class type can't be converted. Consider using NSString"];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeDouble)
    {
        [NSException raise:NSInvalidArgumentException format:@"double type can't be converted. Consider using NSNumber."];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeFloat)
    {
        [NSException raise:NSInvalidArgumentException format:@"float type can't be converted. Consider using NSNumber."];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeBitField)
    {
        [NSException raise:NSInvalidArgumentException format:@"bitfield type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeUnsignedChar)
    {
        [NSException raise:NSInvalidArgumentException format:@"unsigned char type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeVoid)
    {
        [NSException raise:NSInvalidArgumentException format:@"void type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeUnknown)
    {
        [NSException raise:NSInvalidArgumentException format:@"unknown type can't be converted"];
    }
}

- (void*)convertNumericTypes:(NSString*)stringValue typeDescriptor:(TyphoonTypeDescriptor*)typeDescriptor
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeInt)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) converted;
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeUnsignedInt)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) [[NSNumber numberWithUnsignedInt:converted] unsignedIntValue];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeShort)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) [[NSNumber numberWithInt:converted] shortValue];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeUnsignedShort)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) [[NSNumber numberWithUnsignedInt:converted] unsignedShortValue];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) [[NSNumber numberWithLong:converted] longValue];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeUnsignedLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) [[NSNumber numberWithUnsignedLong:converted] unsignedLongValue];
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeLongLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) converted;
    }
    else if (typeDescriptor.primitiveType == TyphoonPrimitiveTypeUnsignedLongLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) [[NSNumber numberWithUnsignedLongLong:converted] unsignedLongLongValue];
    }
    return nil;
}

@end