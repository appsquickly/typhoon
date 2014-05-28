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

#import <XCTest/XCTest.h>
#import "TyphoonTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import <UIKit/UIKit.h>

@interface TyphoonUIColorConverterTests : XCTestCase

@property(nonatomic, strong, readonly) UIColor *color;
@property(nonatomic, strong) id <TyphoonTypeConverter> converter;

@end

@implementation TyphoonUIColorConverterTests

- (void)setUp
{
    [super setUp];
    self.converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"UIColor"];

}

- (void)assertColor:(UIColor *)color red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    assertThat(color, notNilValue());

    CGFloat redComponent, greenComponent, blueComponent, alphaComponent;
    [color getRed:&redComponent green:&greenComponent blue:&blueComponent alpha:&alphaComponent];

    assertThatFloat(redComponent, equalToFloat(red));
    assertThatFloat(greenComponent, equalToFloat(green));
    assertThatFloat(blueComponent, equalToFloat(blue));
    assertThatFloat(alphaComponent, equalToFloat(alpha));
}

- (void)test_converts_hex_string
{
    UIColor *color = [self.converter convert:@"UIColor(#ffffff)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:1.0f];
}

- (void)test_converts_hex_string_with_alpha
{
    UIColor *color = [self.converter convert:@"UIColor(#00ffffff)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:0.0f];
}

- (void)test_converts_css_style_rgb
{
    UIColor *color = [self.converter convert:@"UIColor(255,255,255)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:1.0f];
}

- (void)test_converts_css_style_rgba
{
    UIColor *color = [self.converter convert:@"UIColor(255,255,255,0.5)"];
    [self assertColor:color red:1.0f green:1.0f blue:1.0f alpha:0.5f];
}

@end