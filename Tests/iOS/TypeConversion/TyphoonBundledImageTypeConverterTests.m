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

@interface TyphoonBundledImageTypeConverterTests : XCTestCase

@property(nonatomic, strong) id <TyphoonTypeConverter> converter;

@end

@implementation TyphoonBundledImageTypeConverterTests

- (void)setUp {
    [super setUp];
    self.converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"UIImage"];
}

- (void)tearDown {
    self.converter = nil;
    [super tearDown];
}

- (void)test_converts_image_in_bundle
{
    UIImage *image = [self.converter convert:@"UIImage(star)"];
    XCTAssertNotNil(image);
}

- (void)test_does_not_convert_image_not_in_bundle
{
    UIImage *image = [self.converter convert:@"UIImage(non-star)"];
    XCTAssertNil(image);
}

@end
