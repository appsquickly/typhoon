////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@interface NSInvocation (TCFWrapValues)

/** Get argument at index, wrapping primitive values in NSValue if needed */
- (id)typhoon_getArgumentObjectAtIndex:(NSInteger)idx;

@end
