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


#import "SpringPrimitiveTypeConverter.h"
#import "SpringTypeDescriptor.h"
#import "SpringLogTemplate.h"


@implementation SpringPrimitiveTypeConverter


- (void*)convert:(NSString*)stringValue requiredType:(SpringTypeDescriptor*)typeDescriptor
{
    SpringDebug(@"Converting value: %@", stringValue);
    [self checkSupportedTypes:typeDescriptor];
    if (typeDescriptor.primitiveType == SpringPrimitiveTypeBoolean || typeDescriptor.primitiveType == SpringPrimitiveTypeChar)
    {
        return (void*) [stringValue boolValue];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeString)
    {
        return (void*) [stringValue cStringUsingEncoding:NSUTF8StringEncoding];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeSelector)
    {
        return (void*) NSSelectorFromString(stringValue);
    }
    return [self convertNumericTypes:stringValue typeDescriptor:typeDescriptor];
}


/* ============================================================ Private Methods ========================================================= */
- (void)checkSupportedTypes:(SpringTypeDescriptor*)typeDescriptor
{
    if (typeDescriptor.isArray)
    {
        [NSException raise:NSInvalidArgumentException format:@"Array type not yet supported"];
    }
    else if (typeDescriptor.isStructure)
    {
        [NSException raise:NSInvalidArgumentException format:@"Structure type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeClass)
    {
        [NSException raise:NSInvalidArgumentException format:@"Class type can't be converted. Consider using NSString"];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeDouble)
    {
        [NSException raise:NSInvalidArgumentException format:@"double type can't be converted. Consider using NSNumber."];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeFloat)
    {
        [NSException raise:NSInvalidArgumentException format:@"float type can't be converted. Consider using NSNumber."];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeBitField)
    {
        [NSException raise:NSInvalidArgumentException format:@"bitfield type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeUnsignedChar)
    {
        [NSException raise:NSInvalidArgumentException format:@"unsigned char type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeVoid)
    {
        [NSException raise:NSInvalidArgumentException format:@"void type can't be converted"];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeUnknown)
    {
        [NSException raise:NSInvalidArgumentException format:@"unknown type can't be converted"];
    }
}

- (void*)convertNumericTypes:(NSString*)stringValue typeDescriptor:(SpringTypeDescriptor*)typeDescriptor
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
    if (typeDescriptor.primitiveType == SpringPrimitiveTypeInt)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) converted;
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeUnsignedInt)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) [[NSNumber numberWithUnsignedInt:converted] unsignedIntValue];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeShort)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) [[NSNumber numberWithInt:converted] shortValue];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeUnsignedShort)
    {
        int converted = 0;
        [scanner scanInt:&converted];
        return (void*) [[NSNumber numberWithUnsignedInt:converted] unsignedShortValue];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) [[NSNumber numberWithLong:converted] longValue];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeUnsignedLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) [[NSNumber numberWithUnsignedLong:converted] unsignedLongValue];
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeLongLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) converted;
    }
    else if (typeDescriptor.primitiveType == SpringPrimitiveTypeUnsignedLongLong)
    {
        long long converted = 0;
        [scanner scanLongLong:&converted];
        return (void*) [[NSNumber numberWithUnsignedLongLong:converted] unsignedLongLongValue];
    }
    return nil;
}

@end