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
#import "TyphoonAssistedFactoryMethodInitializer.h"

@class TyphoonAssistedFactoryDefinition;


/** Used to configure the TyphoonAssistedFactoryDefinition passed as argument */
typedef void(^TyphoonAssistedFactoryDefinitionBlock)(TyphoonAssistedFactoryDefinition *definition);

/** Used to enumerate over factory method selectors and their associated body blocks */
typedef void(^TyphoonAssistedFactoryMethodsEnumerationBlock)(id <TyphoonAssistedFactoryMethod> factoryMethod);

/** Used to configure a TyphoonAssistedFactoryMethod */
typedef void(^TyphoonAssistedFactoryMethodInitializerBlock)(TyphoonAssistedFactoryMethodInitializer *initializer);

@interface TyphoonAssistedFactoryDefinition : NSObject

/**
 * Define a new factory method with the given selector and associating the given
 * block. The block should return a value. The arguments of the block are the
 * arguments of the factory method in the same order, but the factory itself is
 * prefixed as first argument, so the factory method arguments are the second
 * and following arguments.
 */
- (void)factoryMethod:(SEL)name body:(id)bodyBlock;

/**
 * Define a new factory method with the given selector, returning the given type
 * and using the configured TyphoonAssistedFactoryInitializer. During the
 * initialization block you should set the selector of the initializer and also
 * configure each of the parameters of that selector pointing to either one
 * property, or one of the factory method arguments (referred either by
 * positional index or name).
 */
- (void)factoryMethod:(SEL)name returns:(Class)returnType initialization:(TyphoonAssistedFactoryMethodInitializerBlock)initialization;

#pragma mark - Internal methods

/**
 * The number of factory methods defined for this assisted factory. Users should
 * not invoke this method directly.
 */
@property(nonatomic, assign, readonly) NSUInteger countOfFactoryMethods;

/**
 * Configure this assisted factory definition inside the block provider as
 * argument. Users should not invoke this method directly.
 */
- (void)configure:(TyphoonAssistedFactoryDefinitionBlock)configurationBlock;

/**
 * Enumerate over all the defined factory method. The block will be invoked once
 * per factory method, receiving the selector and the body block associated for
 * each factory method. Users should not invoke this method directly.
 */
- (void)enumerateFactoryMethods:(TyphoonAssistedFactoryMethodsEnumerationBlock)enumerationBlock;

@end
