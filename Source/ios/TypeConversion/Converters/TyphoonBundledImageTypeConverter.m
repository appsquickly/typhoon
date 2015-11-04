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


#import "TyphoonBundledImageTypeConverter.h"
#import <UIKit/UIKit.h>


@implementation TyphoonBundledImageTypeConverter

- (id)supportedType
{
    return @"UIImage";
}

- (id)convert:(NSString *)stringValue
{
    stringValue = [TyphoonTypeConversionUtils textWithoutTypeFromTextValue:stringValue];
    __autoreleasing UIImage *image = [UIImage imageNamed:stringValue];
    return image;
}


@end
