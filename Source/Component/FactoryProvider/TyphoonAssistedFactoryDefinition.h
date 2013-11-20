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

#import "TyphoonAssistedFactoryMethodInitializer.h"

@class TyphoonAssistedFactoryDefinition;

/** Used to configure the TyphoonAssistedFactoryDefinition passed as argument */
typedef void(^TyphoonAssistedFactoryDefinitionBlock)(TyphoonAssistedFactoryDefinition *definition);

/** Used to enumerate over factory method selectors and their associated body blocks */
typedef void(^TyphoonAssistedFactoryMethodsEnumerationBlock)(id<TyphoonAssistedFactoryMethod> factoryMethod);

@interface TyphoonAssistedFactoryDefinition : NSObject

/**
 * Define a new factory method with the given selector and associating the given
 * block. The block should return a value. The arguments of the block are the
 * arguments of the factory method in the same order, but the factory itself is
 * prefixed as first argument, so the factory method arguments are the second
 * and following arguments.
 */
- (void)factoryMethod:(SEL)name body:(id)bodyBlock;

- (void)factoryMethod:(SEL)name returns:(Class)returnType initialization:(TyphoonAssistedFactoryInitializerBlock)initialization;

#pragma mark - Internal methods

/**
 * The number of factory methods defined for this assisted factory. Users should
 * not invoke this method directly.
 */
@property (nonatomic, assign, readonly) NSUInteger countOfFactoryMethods;

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
