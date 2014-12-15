////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
///////////////////////////////////////////////////////// ///////////////////////


#import <XCTest/XCTest.h>
#import "TyphoonUtils.h"


@interface TyphoonStringUtilsTests : XCTestCase


@end


@implementation TyphoonStringUtilsTests

- (void)test_same_strings
{
    XCTAssertTrue(CStringEquals("123", "123"));
}

- (void)test_different_strings
{
    XCTAssertFalse(CStringEquals("123", "321"));
}

- (void)test_same_pointer_strings
{
    const char *str = "123";
    XCTAssertTrue(CStringEquals(str, str));
}

@end