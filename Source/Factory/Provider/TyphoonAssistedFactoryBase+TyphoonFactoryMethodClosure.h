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

#import "TyphoonAssistedFactoryBase.h"

@protocol TyphoonAssistedFactoryMethodClosure;

/**
 * Complements TyphoonAssistedFactoryBase to allow methods defined by closures.
 * The implementation overrides methodSignatureForSelector and forwardInvocation
 * to implement the methods defined by the closures.
 *
 * Even if this class is "internal", the prefixes avoid the possibility of the
 * user defining some factory method with the same name.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryBase (TyphoonFactoryMethodClosure)

/**
 * Sets the given closure for the given selector.
 */
+ (void)_fmc_setClosure:(id <TyphoonAssistedFactoryMethodClosure>)closure forSelector:(SEL)selector;

/**
 * Returns the closure associated with the given selector.
 */
+ (id <TyphoonAssistedFactoryMethodClosure>)_fmc_closureForSelector:(SEL)selector;

@end
