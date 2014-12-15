////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "NSMethodSignature+TCFUnwrapValues.h"
#import "TyphoonUtils.h"

@implementation NSMethodSignature (TCFUnwrapValues)

- (BOOL)shouldUnwrapValue:(id)value forArgumentAtIndex:(NSUInteger)index
{
    const char *argumentType = [self getArgumentTypeAtIndex:index];
    
    BOOL isPrimitive = !CStringEquals(argumentType, @encode(id));
    BOOL isObjectIsWrapper = [value isKindOfClass:[NSValue class]];
    
    return isPrimitive && isObjectIsWrapper;
}

@end
