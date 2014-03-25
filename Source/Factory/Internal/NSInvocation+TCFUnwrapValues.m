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
#import "NSMethodSignature+TCFUnwrapValues.h"

@implementation NSInvocation (TCFUnwrapValues)

- (void)typhoon_setArgumentObject:(id)object atIndex:(NSInteger)idx
{
    BOOL isValue = [object isKindOfClass:[NSValue class]];
    
    if (isValue) {
        const char *argumentType = [[self methodSignature] getArgumentTypeAtIndex:idx];
        [(NSValue *)object typhoon_setAsArgumentWithType:argumentType forInvocation:self atIndex:idx];
    } else {
        [self setArgument:&object atIndex:idx];
    }
}

@end

