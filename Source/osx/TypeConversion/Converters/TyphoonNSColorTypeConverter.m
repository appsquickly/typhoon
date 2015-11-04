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

#import "TyphoonNSColorTypeConverter.h"

#import "TyphoonColorConversionUtils.h"

@implementation TyphoonNSColorTypeConverter

- (id)supportedType
{
    return @"NSColor";
}

- (id)convert:(NSString *)stringValue
{
    stringValue = [TyphoonTypeConversionUtils textWithoutTypeFromTextValue:stringValue];
    
    struct RGBA color;
    
    if ([stringValue hasPrefix:@"#"] || [stringValue hasPrefix:@"0x"]) {
        color = [TyphoonColorConversionUtils colorFromHexString:stringValue];
    }
    else {
        color = [TyphoonColorConversionUtils colorFromCssStyleString:stringValue];
    }
    
    return [self colorFromRGBA:color];
}

- (NSColor *)colorFromRGBA:(struct RGBA)rgba
{
    return [NSColor colorWithRed:rgba.red green:rgba.green blue:rgba.blue alpha:rgba.alpha];
}

@end
