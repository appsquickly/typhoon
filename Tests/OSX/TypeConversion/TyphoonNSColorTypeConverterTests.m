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

#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeConverter.h"

@interface TyphoonNSColorTypeConverterTests : XCTestCase

@property(nonatomic, strong, readonly) NSColor *color;
@property(nonatomic, strong) id <TyphoonTypeConverter> converter;

@end

@implementation TyphoonNSColorTypeConverterTests

- (void)setUp {
    [super setUp];
    
    TyphoonTypeConverterRegistry *registry = [[TyphoonTypeConverterRegistry alloc] init];
    self.converter = [registry converterForType:@"NSColor"];
}

- (void)tearDown {
    self.converter = nil;
    
    [super tearDown];
}

- (void)assertColor:(NSColor *)color red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    XCTAssertNotNil(color);
    
    CGFloat redComponent, greenComponent, blueComponent, alphaComponent;
    [color getRed:&redComponent green:&greenComponent blue:&blueComponent alpha:&alphaComponent];
    
    XCTAssertEqual(redComponent, red);
    XCTAssertEqual(greenComponent, green);
    XCTAssertEqual(blueComponent, blue);
    XCTAssertEqual(alphaComponent, alpha);
}

- (void)test_converts_hex_string
{
    NSColor *color = [self.converter convert:@"NSColor(#ffffff)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:1.0f];
}

- (void)test_converts_hex_string_with_alpha
{
    NSColor *color = [self.converter convert:@"NSColor(#00ffffff)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:0.0f];
}

- (void)test_converts_css_style_rgb
{
    NSColor *color = [self.converter convert:@"NSColor(255,255,255)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:1.0f];
}

- (void)test_converts_css_style_rgba
{
    NSColor *color = [self.converter convert:@"NSColor(255,255,255,0.5)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:0.5f];
}

@end
