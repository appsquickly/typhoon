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

#import <SenTestingKit/SenTestingKit.h>
#import "OCLogTemplate.h"
#import "TyphoonTestUtils.h"

@interface TyphoonTestUtilsTests : SenTestCase

@end

@implementation TyphoonTestUtilsTests

- (void)test_should_waitForCondition_to_occur
{

    __block NSString* willLoadLater = nil;
    dispatch_async(dispatch_queue_create("fetcher.queue", DISPATCH_QUEUE_CONCURRENT), ^(void)
    {
        LogDebug(@"Loading remote data. . . ");
        [NSThread sleepForTimeInterval:0.05];
        willLoadLater = @"Foobar!";
    });

    [TyphoonTestUtils waitForCondition:^BOOL()
    {
        typhoon_asynch_condition(willLoadLater != nil);
    }];
}

- (void)test_should_throw_an_exception_if_condition_does_not_occur
{

    NSString* willNeverLoad = nil;
    @try
    {
        [TyphoonTestUtils wait:0.1 secondsForCondition:^BOOL()
        {
            typhoon_asynch_condition(willNeverLoad != nil);
        } andPerformTests:nil];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Condition didn't happen before timeout: 0.100000"));
    }


}

@end