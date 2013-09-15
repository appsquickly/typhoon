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


#import "TyphoonUIColorTypeConverter.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>



@implementation TyphoonUIColorTypeConverter

- (id)convert:(NSString*)stringValue
{
    NSUInteger red, green, blue;
    sscanf([stringValue UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

@end