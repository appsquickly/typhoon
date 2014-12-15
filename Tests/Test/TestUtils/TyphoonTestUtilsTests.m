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
#import "OCLogTemplate.h"
#import "TyphoonTestUtils.h"

@interface TyphoonTestUtilsTests : XCTestCase

@end

@implementation TyphoonTestUtilsTests

- (void)test_should_waitForCondition_to_occur
{

    __block NSString *willLoadLater = nil;
    dispatch_async(dispatch_queue_create("fetcher.queue", DISPATCH_QUEUE_CONCURRENT), ^(void) {
        LogDebug(@"Loading remote data. . . ");
        [NSThread sleepForTimeInterval:0.01];
        willLoadLater = @"Foobar!";
    });

    [TyphoonTestUtils waitForCondition:^BOOL() {
        return willLoadLater != nil;
    }];
}

- (void)test_should_throw_an_exception_if_condition_does_not_occur
{

    NSString *willNeverLoad = nil;
    @try {
        [TyphoonTestUtils wait:0.01 secondsForCondition:^BOOL() {
            return willNeverLoad != nil;
        } andPerformTests:nil];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Condition didn't happen before timeout: 0.010000");
    }


}

@end