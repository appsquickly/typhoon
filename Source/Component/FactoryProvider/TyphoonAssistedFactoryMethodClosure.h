////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

#include <objc/runtime.h>


@class TyphoonAssistedFactoryMethodInitializer;

/**
 * A closure of a factory method. Internally this object stores a description of
 * both the factory method and the init method. Each time you invoke the
 * factory method (through forwardInvocation) the mapping described in the method
 * initializer will be performed, and the call will be forwarded.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryMethodClosure : NSObject

@property (nonatomic, retain, readonly) NSMethodSignature *methodSignature;

/**
 * Creates a new closure from the description of the initializer, for the
 * factory method described by methodSignature.
 */
- (instancetype)initWithInitializer:(TyphoonAssistedFactoryMethodInitializer *)initializer methodSignature:(NSMethodSignature *)methodSignature;

/**
 * Returns an invocation filled with the right target instance, the right init
 * selector and the arguments according to the initializer parameters, using
 * factory to find the property values, and forwardedInvocation to find the
 * arguments to the factory method.
 */
- (NSInvocation *)invocationWithFactory:(id)factory forwardedInvocation:(NSInvocation *)anInvocation;

@end
