////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <XCTest/XCTest.h>
#import "NSObject+DeallocNotification.h"

@interface TyphoonObjectDeallocCallbackTests : XCTestCase

@end

@implementation TyphoonObjectDeallocCallbackTests

- (void)test_callback
{
    NSObject *object = [NSObject new];

    __block BOOL notificationCalled = NO;

    [object setDeallocNotificationInBlock:^{
        notificationCalled = YES;
    }];

    object = nil;

    XCTAssertTrue(notificationCalled);
}

- (void)test_callback_removing
{
    NSObject *object = [NSObject new];

    __block BOOL notificationCalled = NO;

    [object setDeallocNotificationInBlock:^{
        notificationCalled = YES;
    }];

    [object removeDeallocNotification];

    object = nil;

    XCTAssertFalse(notificationCalled);
}

@end
