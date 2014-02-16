////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSObject+DeallocNotification.h"
#import <objc/runtime.h>


///////////////////// Object with Dealloc callback ///////////////////////////////////////////////////////////////


/**
 * DeallocCallbackObject notify in deallocCallback block when dealloced
 */
@interface DeallocCallbackObject : NSObject

- (id)initWithDeallocCallback:(dispatch_block_t)deallocCallback;

- (void)removeCallback;

@end

@implementation DeallocCallbackObject
{
    dispatch_block_t callback;
}

- (id)initWithDeallocCallback:(dispatch_block_t)deallocCallback
{
    NSParameterAssert(deallocCallback);
    self = [super init];
    if (self) {
        callback = [deallocCallback copy];
    }
    return self;
}

- (void)removeCallback
{
    callback = nil;
}

- (void)dealloc
{
    if (callback) {
        callback();
    }
}

@end

/////////////////////////////// DeallocNotifier ///////////////////////////////////////////////////////////////

@implementation NSObject (DeallocNotifier)

static const char *kTyphoonDefaultDeallocNotifierKey = "kTyphoonDefaultDeallocNotifierKey";

- (void)setDeallocNotificationInBlock:(dispatch_block_t)block
{
    [self setDeallocNotificationWithKey:kTyphoonDefaultDeallocNotifierKey andBlock:block];
}

- (void)removeDeallocNotification
{
    [self removeDeallocNotificationForKey:kTyphoonDefaultDeallocNotifierKey];
}

- (void)setDeallocNotificationWithKey:(const char *)key andBlock:(dispatch_block_t)block
{
    DeallocCallbackObject *deallocNotifier = [[DeallocCallbackObject alloc] initWithDeallocCallback:block];
    objc_setAssociatedObject(self, key, deallocNotifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeDeallocNotificationForKey:(const char *)key
{
    DeallocCallbackObject *deallocNotifier = objc_getAssociatedObject(self, key);
    [deallocNotifier removeCallback];
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
