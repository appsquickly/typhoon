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

#include "TyphoonAssistedFactoryMethodClosure.h"


@class TyphoonAssistedFactoryMethodInitializer;

/**
 * A closure of a factory method. Internally this object stores a description of
 * both the factory method and the init method. Each time you invoke the
 * factory method (through forwardInvocation) the mapping described in the method
 * initializer will be performed, and the call will be forwarded.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryMethodInitializerClosure : NSObject <TyphoonAssistedFactoryMethodClosure>

/**
 * Creates a new closure from the description of the initializer, for the
 * factory method described by methodSignature.
 */
- (instancetype)initWithInitializer:(TyphoonAssistedFactoryMethodInitializer *)initializer
    methodSignature:(NSMethodSignature *)methodSignature;

@end
