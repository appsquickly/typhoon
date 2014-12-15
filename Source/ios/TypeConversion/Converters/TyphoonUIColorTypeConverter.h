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



#import "TyphoonTypeConverter.h"

/**
* A type converter for UIColor.
*
* The formats supported are:
* Hexadecimal, #RRGGBB or #AARRGGBB
* Css-style, rgb(r,g,b) or rgba(r,g,b,a)
*
*/
@interface TyphoonUIColorTypeConverter : NSObject <TyphoonTypeConverter>

@end
