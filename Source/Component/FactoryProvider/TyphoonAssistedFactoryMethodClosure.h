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
 * factory method (through fptr) the mapping described in the method
 * initializer will be done, and the call will be forwarded.
 */
@interface TyphoonAssistedFactoryMethodClosure : NSObject

/**
 * Creates a new closure from the description of the initializer, for the
 * factory method described by methodDescription.
 */
- (instancetype)initWithInitializer:(TyphoonAssistedFactoryMethodInitializer *)initializer methodDescription:(struct objc_method_description)methodDescription;

/** Returns the function pointer that can be use as IMP of the factory method */
- (void *)fptr;

@end
