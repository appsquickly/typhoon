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


#import "TyphoonNSNumberTypeConverter.h"


@implementation TyphoonNSNumberTypeConverter

- (id)supportedType
{
    return @"NSNumber";
}

- (id)convert:(NSString *)stringValue
{
    stringValue = [TyphoonTypeConversionUtils textWithoutTypeFromTextValue:stringValue];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    __autoreleasing NSNumber *number = [f numberFromString:stringValue];
    return number;

}

@end
