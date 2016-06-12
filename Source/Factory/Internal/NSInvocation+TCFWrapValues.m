////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "NSInvocation+TCFWrapValues.h"
#import "TyphoonUtils.h"
#import "TyphoonIntrospectionUtils.h"

@implementation NSInvocation (TCFWrapValues)

- (id)typhoon_getArgumentObjectAtIndex:(NSInteger)idx
{
    return [self typhoon_getArgumentAtIndex:idx orInvocationReturnValueIfNeeded:NO];
}

- (id)typhoon_getReturnValue
{
    return [self typhoon_getArgumentAtIndex:NSNotFound orInvocationReturnValueIfNeeded:YES];
}

- (id)typhoon_getArgumentAtIndex:(NSInteger)idx orInvocationReturnValueIfNeeded:(BOOL)getReturnValueIfNeeded
{
    const char *type;

    if (getReturnValueIfNeeded) {
        type = [self.methodSignature methodReturnType];
    } else {
        type = [self.methodSignature getArgumentTypeAtIndex:(NSUInteger)idx];
    }

    if (CStringEquals(type, "@") || // object
            CStringEquals(type, "@?") || // block
            CStringEquals(type, "#")) // metaclass
    {
        void *pointer;

        if (getReturnValueIfNeeded) {
            [self getReturnValue:&pointer];
        } else {
            [self getArgument:&pointer atIndex:idx];
        }

        id returnValue = (__bridge id)pointer;

        if (IsBlock(type)) {
            return [returnValue copy]; // Converting NSStackBlock to NSMallocBlock
        }

        return returnValue;
    } else {
        NSUInteger returnValueSize;
        NSGetSizeAndAlignment(type, &returnValueSize, NULL);

        void *buffer = malloc(returnValueSize);

        if (getReturnValueIfNeeded) {
            [self getReturnValue:buffer];
        } else {
            [self getArgument:buffer atIndex:idx];
        }

        id returnValue = [NSValue valueWithBytes:buffer objCType:type];

        free(buffer);
        return returnValue;
    }
}

@end
