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

#import "NSValue+TCFUnwrapValues.h"
#import "TyphoonStringUtils.h"

@implementation NSValue (TCFUnwrapValues)

- (void)typhoon_setAsArgumentWithType:(const char *)argumentType forInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index
{
    NSUInteger argumentSize;
    NSGetSizeAndAlignment(argumentType, &argumentSize, NULL);

    const char *valueType = [self objCType];
    if (!CStringEquals(valueType, argumentType)) {
        NSUInteger valueSize;
        NSGetSizeAndAlignment(valueType, &valueSize, NULL);
        NSAssert(valueSize <= argumentSize, @"Trying to inject NSValue with type of different size ('%s' expected, but '%s' passed)", argumentType, valueType);
    }

    void *buffer = malloc(argumentSize);
    
    [self getValue:buffer];
    [invocation setArgument:buffer atIndex:index];
    
    free(buffer);
}

@end

@implementation NSNumber (TCFUnwrapValues)

- (void)typhoon_setAsArgumentWithType:(const char *)argumentType forInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index
{
    /* Using argument type instead of number type becuase when numberType mismatch argumentType
     * we should cast to argumentType and then inject */
    const char *type = argumentType;//[self objCType];

    if (CStringEquals(type, @encode(int))) {
        int converted = [self intValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned int))) {
        unsigned int converted = [self unsignedIntValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(char))) {
        char converted = [self charValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned char))) {
        unsigned char converted = [self unsignedCharValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(bool))) {
        bool converted = [self boolValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(short))) {
        short converted = [self shortValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned short))) {
        unsigned short converted = [self unsignedShortValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(float))) {
        float converted = [self floatValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(double))) {
        double converted = [self doubleValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(long))) {
        long converted = [self longValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned long))) {
        unsigned long converted = [self unsignedLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(long long))) {
        long long converted = [self longLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned long long))) {
        unsigned long long converted = [self unsignedLongLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else {
        [NSException raise:@"InvalidNumberType" format:@"Invalid Number: Type '%s' is not supported.", type];
    }
}

@end
