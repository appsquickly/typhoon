//
//  TyphoonObjectDeallocCallbackTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 29.01.14.
//
//

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
