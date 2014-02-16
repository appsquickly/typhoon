//
//  TyphoonObjectDeallocCallbackTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 29.01.14.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+DeallocNotification.h"

@interface TyphoonObjectDeallocCallbackTests : SenTestCase

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

    assertThatBool(notificationCalled, equalToBool(YES));
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

    assertThatBool(notificationCalled, equalToBool(NO));
}

@end
