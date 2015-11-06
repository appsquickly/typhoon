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

#import <Foundation/Foundation.h>

struct RGBA
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
};

@interface TyphoonColorConversionUtils : NSObject

+ (struct RGBA)colorFromHexString:(NSString *)hexString;
+ (struct RGBA)colorFromCssStyleString:(NSString *)cssString;

@end
