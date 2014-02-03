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

    @autoreleasepool
    {
        [self invokeWithTarget:instanceOrClass];

        [self getReturnValue:&returnValue];
        [returnValue retain];
    }

    return returnValue;
}

- (id)typhoon_resultOfInvokingOnInstance:(id)instance
{
    return [self typhoon_resultOfInvokingOn:instance];
}

- (id)typhoon_resultOfInvokingOnAllocationForClass:(Class)aClass
{
    id allocatedSpace = [aClass alloc];
    id instance = [self typhoon_resultOfInvokingOn:allocatedSpace];
    [instance release];
    return instance;
}


@end
