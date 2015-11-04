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

#import "TyphoonTypeConversionUtils.h"

@implementation TyphoonTypeConversionUtils

+ (NSString *)typeFromTextValue:(NSString *)textValue
{
    NSString *type = nil;
    
    NSRange openBraceRange = [textValue rangeOfString:@"("];
    BOOL hasBraces = [textValue hasSuffix:@")"] && openBraceRange.location != NSNotFound;
    if (hasBraces) {
        type = [textValue substringToIndex:openBraceRange.location];
    }
    
    return type;
}

+ (NSString *)textWithoutTypeFromTextValue:(NSString *)textValue
{
    NSString *result = textValue;
    
    NSRange openBraceRange = [textValue rangeOfString:@"("];
    BOOL hasBraces = [textValue hasSuffix:@")"] && openBraceRange.location != NSNotFound;
    
    if (hasBraces) {
        NSRange range = NSMakeRange(openBraceRange.location + openBraceRange.length, 0);
        range.length = [textValue length] - range.location - 1;
        result = [textValue substringWithRange:range];
    }
    
    return result;
}

@end
