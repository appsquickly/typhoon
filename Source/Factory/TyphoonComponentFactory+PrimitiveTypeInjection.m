////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonComponentFactory+PrimitiveTypeInjection.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeDescriptor.h"


@implementation TyphoonComponentFactory (PrimitiveTypeInjection)


- (void)setPrimitiveArgumentFor:(NSInvocation*)invocation index:(NSUInteger)index textValue:(NSString*)textValue
        requiredType:(TyphoonTypeDescriptor*)requiredType
{
    TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
    if (requiredType.primitiveType == TyphoonPrimitiveTypeBoolean || requiredType.primitiveType == TyphoonPrimitiveTypeChar)
    {
        BOOL converted = [converter convertToBoolean:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeClass)
    {
        Class converted = [converter convertToClass:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeDouble)
    {
        double converted = [converter convertToDouble:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeFloat)
    {
        float converted = [converter convertToFloat:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeInt)
    {
        int converted = [converter convertToInt:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLong)
    {
        long converted = [converter convertToLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLongLong)
    {
        long long converted = [converter convertToLongLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeSelector)
    {
        SEL converted = [converter convertToSelector:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeString)
    {
        const char* converted = [converter convertToCString:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedChar)
    {
        unsigned char converted = [converter convertToUnsignedChar:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedInt)
    {
        unsigned int converted = [converter convertToUnsignedInt:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLong)
    {
        unsigned long converted = [converter convertToUnsignedLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLongLong)
    {
        unsigned long long converted = [converter convertToUnsignedLongLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Type for %@ is not supported.", requiredType];
    }
}


@end