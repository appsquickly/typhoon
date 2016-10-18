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
    const char *argumentType = [self.methodSignature getArgumentTypeAtIndex:(NSUInteger)idx];
    
    if (CStringEquals(argumentType, "@") || // object
        CStringEquals(argumentType, "@?") || // block
        CStringEquals(argumentType, "#")) // metaclass
    {
        void *pointer;
        [self getArgument:&pointer atIndex:idx];
        id argument = (__bridge id) pointer;
        
        if (IsBlock(argumentType)) {
            return [argument copy]; // Converting NSStackBlock to NSMallocBlock
        }
        
        return argument;
    } else {
        NSUInteger argumentSize;
        NSGetSizeAndAlignment(argumentType, &argumentSize, NULL);
        
        void *buffer = malloc(argumentSize);
        [self getArgument:buffer atIndex:idx];
        
        id argument = [NSValue valueWithBytes:buffer objCType:argumentType];
        
        free(buffer);
        return argument;
    }
}

@end
