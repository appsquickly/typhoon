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


#import <Foundation/Foundation.h>

/**
* @ingroup Configuration
*/
@protocol TyphoonResource <NSObject>

/**
* Returns the resource as data.
*/
@property(nonatomic, readonly) NSData *data;

/**
* Returns the resource with the given name, as an NSString using NSUTF8String encoding.
*/
@property(nonatomic, readonly, getter=asString) NSString *string;

@property(nonatomic, readonly) NSURL *url;

/**
* Returns the resource with the given name, using the specified encoding.
*/
- (NSString *)asStringWithEncoding:(NSStringEncoding)encoding;


@end
