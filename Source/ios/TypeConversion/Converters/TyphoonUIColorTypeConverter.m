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


#import "TyphoonUIColorTypeConverter.h"

#import <UIKit/UIKit.h>


@implementation TyphoonUIColorTypeConverter

- (id)supportedType
{
    return @"UIColor";
}

- (UIColor *)colorFromRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(CGFloat)(red / 255.0) green:(CGFloat)(green / 255.0) blue:(CGFloat)(blue / 255.0)
        alpha:alpha];
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    hexString =
        [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] stringByReplacingOccurrencesOfString:@"0x" withString:@""];

    unsigned int red, green, blue, alpha;
    if ([hexString length] == 6) {
        sscanf([hexString UTF8String], "%02X%02X%02X", &red, &green, &blue);
        alpha = 255;
    }
    else if ([hexString length] == 8) {
        sscanf([hexString UTF8String], "%02X%02X%02X%02X", &alpha, &red, &green, &blue);
    }
    else {
        [NSException raise:NSInvalidArgumentException format:@"%@ requires a six or eight digit hex string.",
                                                             NSStringFromClass([self class])];
    }
    return [self colorFromRed:red green:green blue:blue alpha:(CGFloat)(alpha / 255.0)];
}

- (UIColor *)colorFromCssStyleString:(NSString *)cssString
{
    NSArray *colorComponents = [cssString componentsSeparatedByString:@","];

    unsigned int red, green, blue;
    float alpha;
    if ([colorComponents count] == 3) {
        sscanf([cssString UTF8String], "%d,%d,%d", &red, &green, &blue);
        alpha = 1.0;
    }
    else if ([colorComponents count] == 4) {
        sscanf([cssString UTF8String], "%d,%d,%d,%f", &red, &green, &blue, &alpha);
    }
    else {
        [NSException raise:NSInvalidArgumentException format:@"%@ requires css style format UIColor(r,g,b) or UIColor(r,g,b,a).",
                                                             NSStringFromClass([self class])];
    }
    return [self colorFromRed:red green:green blue:blue alpha:alpha];
}

- (id)convert:(NSString *)stringValue
{
    stringValue = [TyphoonTypeConverterRegistry textWithoutTypeFromTextValue:stringValue];

    UIColor *color = nil;

    if ([stringValue hasPrefix:@"#"] || [stringValue hasPrefix:@"0x"]) {
        color = [self colorFromHexString:stringValue];
    }
    else {
        color = [self colorFromCssStyleString:stringValue];
    }
    
    return color;
}

@end
