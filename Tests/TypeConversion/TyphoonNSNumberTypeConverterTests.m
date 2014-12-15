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
#import "TyphoonTypeConverter.h"

@interface TyphoonNSNumberTypeConverterTests : XCTestCase

@property(nonatomic, strong) id <TyphoonTypeConverter> converter;

@end


@implementation TyphoonNSNumberTypeConverterTests

- (void)setUp
{
    [super setUp];
    self.converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSNumber"];
}

- (void)test_converts_integer
{
    NSNumber* number = [self.converter convert:@"5"];
    XCTAssertEqualObjects([NSNumber numberWithInt:5], number);
}

@end