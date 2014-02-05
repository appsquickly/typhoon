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

#import "NSInvocation+TCFInstanceBuilder.h"

#if __has_feature(objc_arc)
#error You have to disable ARC for this file
#endif


@implementation NSInvocation (TCFInstanceBuilder)

/** Returns YES if selector returns retained instance (not autoreleased) */
static BOOL typhoon_IsSelectorReturnsRetained(SEL selector)
{
    NSString *selectorString = NSStringFromSelector(selector);
    
    return [selectorString hasPrefix:@"init"] ||
    [selectorString hasPrefix:@"new"] ||
    [selectorString hasPrefix:@"copy"] ||
    [selectorString hasPrefix:@"mutableCopy"];
}

- (id)typhoon_resultOfInvokingOn:(id)instanceOrClass
{
    id returnValue = nil;
    
    BOOL isReturnsRetained;
    
    @autoreleasepool
    {
        isReturnsRetained = typhoon_IsSelectorReturnsRetained([self selector]);
        [self invokeWithTarget:instanceOrClass];
        [self getReturnValue:&returnValue];
        [returnValue retain]; /* Retain to take ownership on autoreleased object */
    }

    /* Balance retain above if object is not autoreleased */
    if (isReturnsRetained)
    {
        [returnValue release];
    }

    return returnValue;
}

- (id)typhoon_resultOfInvokingOnInstance:(id)instance
{
    return [self typhoon_resultOfInvokingOn:instance];
}

- (id)typhoon_resultOfInvokingOnAllocationForClass:(Class)aClass
{
    /* To static analyser warning:
     * 'firstlyCreatedInstance' is not leak. There is two cases:
     *   1) instance is firstlyCreatedInstance (have same pointer) - then we returning this as retained result
     *   2) instance is not firstlyCreatedInstance (have different pointer) - then 'init...' method responsible
     *   to release 'firstlyCreatedInstance'
     * But clang analyzer dont know this.. */

#ifndef __clang_analyzer__
    id firstlyCreatedInstance = [aClass alloc];
#endif

    return [self typhoon_resultOfInvokingOn:firstlyCreatedInstance];
}


@end
