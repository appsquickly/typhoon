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

- (id)resultOfInvokingOnInstance:(id)instance
{
    id returnValue = nil;

    @autoreleasepool
    {
        [self invokeWithTarget:instance];

        [self getReturnValue:&returnValue];
        [returnValue retain];
    }

    return returnValue;
}




@end
