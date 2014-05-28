////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
///////////////////////////////////////////////////////// ///////////////////////


#import <XCTest/XCTest.h>
#import "TyphoonStringUtils.h"


@interface TyphoonStringUtilsTests : XCTestCase


@end


@implementation TyphoonStringUtilsTests

- (void)test_isAlpha
{
    XCTAssertFalse([TyphoonStringUtils isAlpha:@"1234"]);
    XCTAssertFalse([TyphoonStringUtils isAlpha:@"abc1234"]);
    XCTAssertTrue([TyphoonStringUtils isAlpha:@"abc"]);
}

- (void)test_isAlphaOrSpaces
{
    XCTAssertFalse([TyphoonStringUtils isAlphaOrSpaces:@"1234"]);
    XCTAssertFalse([TyphoonStringUtils isAlphaOrSpaces:@"abc1234"]);

    XCTAssertTrue([TyphoonStringUtils isAlphaOrSpaces:@"abc"]);
    XCTAssertTrue([TyphoonStringUtils isAlphaOrSpaces:@"abc \t\n"]);
}

- (void)test_isAlphaNumeric
{
    XCTAssertTrue([TyphoonStringUtils isAlphanumeric:@"1234"]);
    XCTAssertTrue([TyphoonStringUtils isAlphanumeric:@"abc1234"]);

    XCTAssertFalse([TyphoonStringUtils isAlphanumeric:@"abc \t\n"]);
}

- (void)test_isEmpty
{
    XCTAssertTrue([TyphoonStringUtils isEmpty:@""]);
    XCTAssertFalse([TyphoonStringUtils isEmpty:@"1234"]);
    XCTAssertTrue([TyphoonStringUtils isEmpty:@" \t\n"]);
}

- (void)test_isNotEmpty
{
    XCTAssertFalse([TyphoonStringUtils isNotEmpty:@""]);
    XCTAssertTrue([TyphoonStringUtils isNotEmpty:@"1234"]);
    XCTAssertFalse([TyphoonStringUtils isNotEmpty:@" \t\n"]);
}

- (void)test_isEmailAddress
{
    XCTAssertFalse([TyphoonStringUtils isEmailAddress:@"asdf"]);
    XCTAssertFalse([TyphoonStringUtils isEmailAddress:@"asd@"]);
    XCTAssertTrue([TyphoonStringUtils isEmailAddress:@"asdf@foobar.com"]);
}


@end