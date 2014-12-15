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


#import "TyphoonNSURLTypeConverter.h"


@implementation TyphoonNSURLTypeConverter

- (id)supportedType
{
    return @"NSURL";
}

- (id)convert:(NSString *)stringValue
{
    stringValue = [TyphoonTypeConverterRegistry textWithoutTypeFromTextValue:stringValue];
    __autoreleasing NSURL *url = [NSURL URLWithString:stringValue];
    return url;
}


@end
