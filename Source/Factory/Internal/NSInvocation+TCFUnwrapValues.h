////////////////////////////////////////////////////////////////////////////////
//
// TYPHOON FRAMEWORK
// Copyright 2014, Jasper Blues & Contributors
// All Rights Reserved.
//
// NOTICE: The authors permit you to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface NSInvocation (TCFUnwrapValues)

/** Set object as argument at index, plus unwrap NSValue and NSNumber if needed */
- (void)typhoon_setArgumentObject:(id)object atIndex:(NSInteger)idx;

@end
