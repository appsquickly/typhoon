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

@interface NSInvocation (TyphoonInvocation)

- (id) resultOfInvokingOnInstance:(id)instance NS_RETURNS_RETAINED;

- (id) resultOfInvokingOnAllocationForClass:(Class)aClass NS_RETURNS_RETAINED;

@end
