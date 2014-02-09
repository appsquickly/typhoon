////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>

/**
* @ingroup Configuration
*/
@protocol TyphoonResource <NSObject>

/**
* Returns the resource with the given name, as an NSString using NSUTF8String encoding.
*/
- (NSString *)asString;

/**
* Returns the resource with the given name, using the specified encoding.
*/
- (NSString *)asStringWithEncoding:(NSStringEncoding)encoding;

/**
* Returns the resource as data.
*/
- (NSData *)data;


@end
