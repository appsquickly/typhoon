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

#import "NSInvocation+TyphoonUtils.h"

#if __has_feature(objc_arc)
#error You have to disable ARC for this file
#endif


@implementation NSInvocation (TyphoonUtils)

- (id)typhoon_resultOfInvokingOn:(id)instanceOrClass
{
    id returnValue = nil;

    NSUInteger retainCountBeforeAutorelease;
    NSUInteger retainCountAfterAutorelease;
    
    @autoreleasepool {
        [self invokeWithTarget:instanceOrClass];
        [self getReturnValue:&returnValue];
        [returnValue retain];
        retainCountBeforeAutorelease = [returnValue retainCount];
    }
    retainCountAfterAutorelease = [returnValue retainCount];
    
    /* if retainCount is not chanaged after draining autorelease pool, 
     * that means that object returned as invocation result strongly retained
     * then release to ballance retain before pool draining */
    if (retainCountBeforeAutorelease == retainCountAfterAutorelease) {
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
