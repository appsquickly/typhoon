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

@interface TyphoonLogging : NSObject

/**
 Returns current logging state
 
 @return YES - if logging is enabled/NO - of logging is disabled
 */
+ (BOOL)isLoggingEnabled;

/**
 Sets logging state - enabled or disabled. Default - YES for debug, NO - for release.
 */
+ (void)setLoggingEnabled:(BOOL)enabled;

@end
