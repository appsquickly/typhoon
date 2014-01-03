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

#import "TyphoonAssistedFactoryCreator.h"

/**
 * Creates the full factory class from the given protocol description and
 * creates implementation for the instance methods using the definition in
 * definitionBlock.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryCreatorManyFactories : TyphoonAssistedFactoryCreator

/**
 * Creates a factory creator for the given protocol and using definitionBlock
 * as the recipe for the instance methods in the protocol.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol factories:(TyphoonAssistedFactoryDefinitionBlock)definitionBlock;

@end
