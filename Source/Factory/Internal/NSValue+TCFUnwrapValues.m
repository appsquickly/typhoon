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
    if (CStringEquals(argumentType, @encode(id))) {
        id selfRef = self;
        [invocation setArgument:&selfRef atIndex:index];
    }
    else { //argument is primitive
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
}

@end

@implementation NSNumber (TCFUnwrapValues)

- (void)typhoon_setAsArgumentWithType:(const char *)argumentType forInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index
{
    if (CStringEquals(argumentType, @encode(id))) {
        id converted = self;
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(int))) {
        int converted = [self intValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(unsigned int))) {
        unsigned int converted = [self unsignedIntValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(char))) {
        char converted = [self charValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(unsigned char))) {
        unsigned char converted = [self unsignedCharValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(bool))) {
        bool converted = [self boolValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(short))) {
        short converted = [self shortValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(unsigned short))) {
        unsigned short converted = [self unsignedShortValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(float))) {
        float converted = [self floatValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(double))) {
        double converted = [self doubleValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(long))) {
        long converted = [self longValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(unsigned long))) {
        unsigned long converted = [self unsignedLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(long long))) {
        long long converted = [self longLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(argumentType, @encode(unsigned long long))) {
        unsigned long long converted = [self unsignedLongLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else {
        [NSException raise:@"InvalidNumberType" format:@"Invalid Number: Type '%s' is not supported.", argumentType];
    }
}

@end
