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


#import <Foundation/Foundation.h>

#define typhoon_asynch_condition(expression) return expression;

typedef BOOL (^TyphoonAsynchConditionBlock)();

typedef void (^TyphoonTestAssertionsBlock)();

/**
* @ingroup Test
*
* Provides a utility for performing asynchronous integration tests with Typhoon. If a method dispatches on a background thread or queue,
* and responds via a block or delegate, this class can be used to test the the expected response occurred.
*
*/
@interface TyphoonTestUtils : NSObject

/**
* Waits for a condition to occur. The default time-out is seven seconds, which is the current usability standard for remote request
* round-trips.
*/
+ (void)waitForCondition:(TyphoonAsynchConditionBlock)condition;

/**
* Waits for a condition to occur, and performs additional tests.
*/
+ (void)waitForCondition:(TyphoonAsynchConditionBlock)condition andPerformTests:(TyphoonTestAssertionsBlock)assertions;

/**
* Waits for a condition to occur, and performs additional tests, also overriding the default timeout with the supplied value.
*
* ##Example:
* @code
    __block BusinessDetails* result = nil;
    [_client requestBusinessDetailsWithSuccess:^(BusinessDetails* businessDetails)
    {
        result = businessDetails;
    }];

    [TyphoonTestUtils wait:3 secondsForCondition:^BOOL
    {
        typhoon_asynch_condition(result != nil);
    } andPerformTests:^
    {
        assertThatBool(businessDetails.goldenEgg, equalToBool:YES);
    }];
@endcode
*/
+ (void)wait:(NSTimeInterval)seconds secondsForCondition:(TyphoonAsynchConditionBlock)condition
    andPerformTests:(TyphoonTestAssertionsBlock)assertions;


@end
