////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>

#import "TyphoonTypeConversionUtils.h"

@interface TyphoonTypeConversionUtilsTests : XCTestCase

@end

@implementation TyphoonTypeConversionUtilsTests

- (void)test_obtaining_type_from_text
{
    NSString *testString = @"NSURL(http://typhoonframework.org)";
    NSString *expectedResult = @"NSURL";
    
    NSString *result = [TyphoonTypeConversionUtils typeFromTextValue:testString];
    
    XCTAssertEqualObjects(result, expectedResult);
}

- (void)test_obtaining_text_without_type
{
    NSString *testString = @"NSURL(http://typhoonframework.org)";
    NSString *expectedResult = @"http://typhoonframework.org";
    
    NSString *result = [TyphoonTypeConversionUtils textWithoutTypeFromTextValue:testString];
    
    XCTAssertEqualObjects(result, expectedResult);
}

@end
