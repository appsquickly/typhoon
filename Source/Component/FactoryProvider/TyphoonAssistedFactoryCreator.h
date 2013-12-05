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

#import "TyphoonAssistedFactoryDefinition.h"

/**
 * Creates the full factory class from the given protocol description.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryCreator : NSObject

/**
 * Returns a creator that will use the protocol as a template for the new class,
 * trying to guess which method in the protocol corresponds to which init
 * method in the returnType. If no match could be found, an error will happen
 * during runtime when calling factoryClass.
 */
+ (instancetype)creatorWithProtocol:(Protocol *)protocol returns:(Class)returnType;

/**
 * Returns a creator that will use the protocol as a template for the new class.
 * The protocol should only have one factory method. The factoryBlock will be
 * used as implementation of such method. The arguments of the block are the
 * arguments of the factory method in the same order, but the factory itself is
 * prefixed as first argument, so the factory method arguments are the second
 * and following arguments. If no factory method could be found, or several are
 * found, an error will happen during runtime when calling factoryClass.
 */
+ (instancetype)creatorWithProtocol:(Protocol *)protocol factoryBlock:(id)factoryBlock;

/**
 * Returns a creator that will use the protocol as a template for the new class,
 * while definitionBlock should contain one factory method definition for each
 * of the factory methods in the protocol. If not enough factory method
 * definitions, or more than necessary are found inside the block, an error
 * will happen during runtime when calling factoryClass.
 */
+ (instancetype)creatorWithProtocol:(Protocol *)protocol factories:(TyphoonAssistedFactoryDefinitionBlock)definitionblock;

/**
 * The Class of the factory created. If something was wrongly configured, this
 * method will fail during runtime.
 */
- (Class)factoryClass;

@end
