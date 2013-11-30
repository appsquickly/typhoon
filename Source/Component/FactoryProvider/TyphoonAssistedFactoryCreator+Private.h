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
 * Lazily returns a TyphoonAssistedFactoryDefinition.
 */
typedef TyphoonAssistedFactoryDefinition *(^TyphoonAssistedFactoryDefinitionProvider)(void);

/**
 * Returns the selector of the only possible factory method of the protocol.
 *
 * The protocol should only have one instance method, beside its property
 * getters. Otherwise this method behaviour is undefined.
 */
SEL TyphoonAssistedFactoryCreatorGuessFactoryMethodForProtocol(Protocol *protocol);

@interface TyphoonAssistedFactoryCreator ()
{
@protected
    Protocol *_protocol;
}

/**
 * Creates a new factory creator for the given protocol and the given lazy
 * factory definition.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol factoryDefinitionProvider:(TyphoonAssistedFactoryDefinitionProvider)definitionProvider;

@end
