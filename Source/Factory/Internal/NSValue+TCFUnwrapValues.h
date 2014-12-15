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

@interface NSValue (TCFUnwrapValues)

- (void)typhoon_setAsArgumentForInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index;

@end


/* Since NSNumber is subclass of NSValue, this category lives in same file */
@interface NSNumber (TCFUnwrapValues)

- (void)typhoon_setAsArgumentForInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index;

@end
