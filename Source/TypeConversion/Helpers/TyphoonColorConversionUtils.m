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

#import "TyphoonColorConversionUtils.h"

@implementation TyphoonColorConversionUtils

+ (struct RGBA)colorFromHexString:(NSString *)hexString {
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

+ (struct RGBA)colorFromCssStyleString:(NSString *)cssString {
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

+ (struct RGBA)colorFromRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    struct RGBA color;
    color.red = (CGFloat)(red / 255.0);
    color.green = (CGFloat)(green / 255.0);
    color.blue = (CGFloat)(blue / 255.0);
    color.alpha = (CGFloat)alpha;
    return color;
}

@end
