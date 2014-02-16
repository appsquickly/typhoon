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


#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonStringUtils.h"

@implementation TyphoonPrimitiveTypeConverter


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (int)convertToInt:(NSString *)stringValue
{
    return [stringValue intValue];
}

- (short)convertToShort:(NSString *)stringValue
{
    return (short) [stringValue intValue];
}

- (long)convertToLong:(NSString *)stringValue
{
    return (long) [stringValue longLongValue];
}

- (long long)convertToLongLong:(NSString *)stringValue
{
    return [stringValue longLongValue];
}

- (unsigned char)convertToUnsignedChar:(NSString *)stringValue
{
    return (unsigned char) [stringValue intValue];
}

- (unsigned int)convertToUnsignedInt:(NSString *)stringValue
{
    return (unsigned int) [stringValue longLongValue];
}

- (unsigned short)convertToUnsignedShort:(NSString *)stringValue
{
    return (unsigned short) [stringValue intValue];
}

- (unsigned long)convertToUnsignedLong:(NSString *)stringValue
{
    return (unsigned long) [stringValue longLongValue];
}

- (unsigned long long)convertToUnsignedLongLong:(NSString *)stringValue
{
    return strtoull([stringValue UTF8String], NULL, 0);
}

- (float)convertToFloat:(NSString *)stringValue
{
    return [stringValue floatValue];
}

- (double)convertToDouble:(NSString *)stringValue
{
    return [stringValue doubleValue];
}

- (BOOL)convertToBoolean:(NSString *)stringValue
{
    return [stringValue boolValue];
}

- (const char *)convertToCString:(NSString *)stringValue
{
    return [stringValue cStringUsingEncoding:NSUTF8StringEncoding];
}

- (Class)convertToClass:(NSString *)stringValue
{
    return NSClassFromString(stringValue);
}

- (SEL)convertToSelector:(NSString *)stringValue
{
    return NSSelectorFromString(stringValue);
}

/* ====================================================================================================================================== */
- (id)valueFromText:(NSString *)textValue withType:(TyphoonTypeDescriptor *)requiredType
{
    id value = nil;

    switch (requiredType.primitiveType) {
        case TyphoonPrimitiveTypeBoolean:
            value = [NSNumber numberWithBool:[self convertToBoolean:textValue]];
            break;
        case TyphoonPrimitiveTypeChar:
            value = [NSNumber numberWithChar:[self convertToBoolean:textValue]];
            break;
        case TyphoonPrimitiveTypeDouble:
            value = [NSNumber numberWithDouble:[self convertToDouble:textValue]];
            break;
        case TyphoonPrimitiveTypeFloat:
            value = [NSNumber numberWithFloat:[self convertToFloat:textValue]];
            break;
        case TyphoonPrimitiveTypeInt:
            value = [NSNumber numberWithInt:[self convertToInt:textValue]];
            break;
        case TyphoonPrimitiveTypeShort:
            value = [NSNumber numberWithShort:[self convertToShort:textValue]];
            break;
        case TyphoonPrimitiveTypeLong:
            value = [NSNumber numberWithLong:[self convertToLong:textValue]];
            break;
        case TyphoonPrimitiveTypeLongLong:
            value = [NSNumber numberWithLongLong:[self convertToLongLong:textValue]];
            break;
        case TyphoonPrimitiveTypeUnsignedChar:
            value = [NSNumber numberWithUnsignedChar:[self convertToUnsignedChar:textValue]];
            break;
        case TyphoonPrimitiveTypeUnsignedShort:
            value = [NSNumber numberWithUnsignedShort:[self convertToUnsignedShort:textValue]];
            break;
        case TyphoonPrimitiveTypeBitField:
        case TyphoonPrimitiveTypeUnsignedInt:
            value = [NSNumber numberWithUnsignedInt:[self convertToUnsignedInt:textValue]];
            break;
        case TyphoonPrimitiveTypeUnsignedLong:
            value = [NSNumber numberWithUnsignedLong:[self convertToUnsignedLong:textValue]];
            break;
        case TyphoonPrimitiveTypeUnsignedLongLong:
            value = [NSNumber numberWithUnsignedLongLong:[self convertToUnsignedLongLong:textValue]];
            break;
        case TyphoonPrimitiveTypeClass:
            value = [self convertToClass:textValue];
            break;
        case TyphoonPrimitiveTypeSelector:
        case TyphoonPrimitiveTypeString:
            value = [NSValue valueWithPointer:[self convertToSelector:textValue]];
            break;
        case TyphoonPrimitiveTypeUnknown:
        case TyphoonPrimitiveTypeVoid: {
            /* Inject all pointers to void and unknown pointers just like void pointers */
            if (requiredType.isPointer) {
                void *pointer = [self convertToInt:textValue];
                value = [NSValue valueWithPointer:pointer];
            }
            else {
                [NSException raise:NSInvalidArgumentException format:@"Type for %@ is not supported.", requiredType];
            }
            break;
        }
    }
    return value;
}

- (void)setPrimitiveArgumentFor:(NSInvocation *)invocation index:(NSUInteger)index textValue:(NSString *)textValue
    requiredType:(TyphoonTypeDescriptor *)requiredType
{
    if (requiredType.primitiveType == TyphoonPrimitiveTypeBoolean || requiredType.primitiveType == TyphoonPrimitiveTypeChar) {
        BOOL converted = [self convertToBoolean:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeClass) {
        Class converted = [self convertToClass:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeDouble) {
        double converted = [self convertToDouble:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeFloat) {
        float converted = [self convertToFloat:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeInt) {
        int converted = [self convertToInt:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeShort) {
        short converted = [self convertToShort:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLong) {
        long converted = [self convertToLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLongLong) {
        long long converted = [self convertToLongLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeSelector) {
        SEL converted = [self convertToSelector:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeString) {
        const char *converted = [self convertToCString:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedChar) {
        unsigned char converted = [self convertToUnsignedChar:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedInt) {
        unsigned int converted = [self convertToUnsignedInt:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedShort) {
        unsigned short converted = [self convertToUnsignedShort:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLong) {
        unsigned long converted = [self convertToUnsignedLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLongLong) {
        unsigned long long converted = [self convertToUnsignedLongLong:textValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else {
        [NSException raise:NSInvalidArgumentException format:@"Type for %@ is not supported.", requiredType];
    }
}


@end
