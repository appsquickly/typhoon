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

#import "TyphoonAssistedFactoryMethod.h"

/**
 * Creates the implementation for a TyphoonAssistedFactoryMethod.
 *
 * Abstract class.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryMethodCreator : NSObject

/** Recipe for the implementation that will be created */
@property(nonatomic, strong, readonly) id <TyphoonAssistedFactoryMethod> factoryMethod;

/**
 * Creates the right subclass of TyphoonAssistedFactoryMethodCreator for the
 * given factoryMethod.
 */
+ (instancetype)creatorFor:(id <TyphoonAssistedFactoryMethod>)factoryMethod;

/**
 * Creates the implementation of the factoryMethod belonging to protocol into
 * the given factoryClass. The factory class should be allocated, but not yet
 * registered.
 */
- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass;

@end
