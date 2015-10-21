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

#import "TyphoonLogging.h"

#ifdef DEBUG
    static BOOL kTyphoonLoggingEnabled = YES;
#else
    static BOOL kTyphoonLoggingEnabled = NO;
#endif

@implementation TyphoonLogging

+ (BOOL)isLoggingEnabled {
    return kTyphoonLoggingEnabled;
}

+ (void)setLoggingEnabled:(BOOL)enabled {
    kTyphoonLoggingEnabled = enabled;
}

@end
