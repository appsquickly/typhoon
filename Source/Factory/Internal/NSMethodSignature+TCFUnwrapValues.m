//
//  NSMethodSignature+TCFUnwrapValues.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 23.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "NSMethodSignature+TCFUnwrapValues.h"
#import "TyphoonStringUtils.h"

@implementation NSMethodSignature (TCFUnwrapValues)

- (BOOL)shouldUnwrapValue:(id)value forArgumentAtIndex:(NSUInteger)index
{
    const char *argumentType = [self getArgumentTypeAtIndex:index];
    
    BOOL isPrimitive = !CStringEquals(argumentType, @encode(id));
    BOOL isObjectIsWrapper = [value isKindOfClass:[NSValue class]];
    
    return isPrimitive && isObjectIsWrapper;
}

@end
