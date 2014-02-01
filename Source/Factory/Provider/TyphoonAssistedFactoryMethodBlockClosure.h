////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

#import "TyphoonAssistedFactoryMethodClosure.h"

/**
 * A closure of a factory method. Internally this object stores a description of
 * both the factory method and the init method selector. Each time you invoke the
 * factory method (through forwardInvocation) a simple 1-to-1 mapping of the
 * arguments will be performed, and the call will be forwarded.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryMethodBlockClosure : NSObject <TyphoonAssistedFactoryMethodClosure>

/**
 * Creates a new closure pointing to the given selector, for the factory method
 * described by methodSignature.
 */
- (instancetype)initWithSelector:(SEL)selector methodSignature:(NSMethodSignature *)methodSignature;

@end
