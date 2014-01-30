//
//  TyphoonInvocation.m
//  Pods
//
//  Created by Aleksey Garbarev on 30.01.14.
//
//

#import "TyphoonInvocation.h"

#if __has_feature(objc_arc)
#error You have to disable ARC for this file
#endif


@implementation NSInvocation (TyphoonInvocation)

- (id) resultOfInvokingOn:(id)instanceOrClass
{
    id returnValue = nil;
    
    @autoreleasepool {
        [self invokeWithTarget:instanceOrClass];
    
        [self getReturnValue:&returnValue];
        [returnValue retain];
    }

    return returnValue;
}

- (id) resultOfInvokingOnInstance:(id)instance
{
    return [self resultOfInvokingOn:instance];
}

- (id) resultOfInvokingOnAllocationForClass:(Class)aClass
{
    id allocatedSpace = [aClass alloc];
    id instance = [self resultOfInvokingOn:allocatedSpace];
    [instance release];
    NSAssert([instance retainCount] == 1, @"RetainCount here must me 1 (not %lu)",(unsigned long)[instance retainCount]);
    return instance;
}


@end
