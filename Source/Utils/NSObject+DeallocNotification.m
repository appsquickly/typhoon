//
//  NSObject+DeallocNotification.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 29.01.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "NSObject+DeallocNotification.h"
#import <objc/runtime.h>


///////////////////// Object with Dealloc callback ///////////////////////////////////////////////////////////////


/**
 * DeallocCallbackObject notify in deallocCallback block when dealloced
 */
@interface DeallocCallbackObject : NSObject

- (id) initWithDeallocCallback:(dispatch_block_t)deallocCallback;
- (void) removeCallback;

@end

@implementation DeallocCallbackObject {
    dispatch_block_t callback;
}

- (id) initWithDeallocCallback:(dispatch_block_t)deallocCallback
{
    NSParameterAssert(deallocCallback);
    self = [super init];
    if (self) {
        callback = [deallocCallback copy];
    }
    return self;
}

- (void) removeCallback
{
    callback = nil;
}

- (void) dealloc
{
    if (callback) {
        callback();
    }
}

@end

/////////////////////////////// DeallocNotifier ///////////////////////////////////////////////////////////////

@implementation NSObject (DeallocNotifier)

static const char *kDeallocNotifierKey;

- (void) setDeallocNotificationInBlock:(dispatch_block_t)block
{
    DeallocCallbackObject *deallocNotifier = [[DeallocCallbackObject alloc] initWithDeallocCallback:block];
    objc_setAssociatedObject(self, &kDeallocNotifierKey, deallocNotifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) removeDeallocNotification
{
    DeallocCallbackObject *deallocNotifier = objc_getAssociatedObject(self, &kDeallocNotifierKey);
    [deallocNotifier removeCallback];
    objc_setAssociatedObject(self, &kDeallocNotifierKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
