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
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeConverter.h"

@interface TyphoonPassThroughTypeConverterTests : XCTestCase

@property NSString *aStringProperty;
@property NSMutableString *aMutableStringProperty;


@end

@implementation TyphoonPassThroughTypeConverterTests

- (void)test_forwards_NSString
{
    id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSString"];
    NSString *converted = [converter convert:@"foobar foobar"];
    XCTAssertEqual(converted, @"foobar foobar");
    XCTAssertTrue([converted isKindOfClass:[NSString class]]);
}

- (void)test_forwards_NSMutableString
{
    id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSMutableString"];
    NSString *converted = [converter convert:@"foobar foobar"];
    XCTAssertEqualObjects(converted, @"foobar foobar");
    XCTAssertTrue([converted isKindOfClass:[NSMutableString class]]);
}

@end