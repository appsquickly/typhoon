////////////////////////////////////////////////////////////////////////////////
//
// TYPHOON FRAMEWORK
// Copyright 2014, Jasper Blues & Contributors
// All Rights Reserved.
//
// NOTICE: The authors permit you to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSInvocation+TCFUnwrapValues.h"
#import "NSValue+TCFUnwrapValues.h"
#import "TyphoonStringUtils.h"

@implementation NSInvocation (TCFUnwrapValues)

- (void)typhoon_setArgumentObject:(id)object atIndex:(NSInteger)idx
{
    const char *argumentType = [[self methodSignature] getArgumentTypeAtIndex:idx];
    
    BOOL isPrimitive = !CStringEquals(argumentType, @encode(id));
    BOOL isObjectIsWrapper = [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSValue class]];
    
    if (isPrimitive && isObjectIsWrapper) {
        [(NSValue *)object typhoon_setAsArgumentWithType:argumentType forInvocation:self atIndex:idx];
    } else {
        [self setArgument:&object atIndex:idx];
    }
}

@end

