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

#include <objc/runtime.h>

/**
 * Lazily returns a TyphoonAssistedFactoryDefinition.
 */
typedef TyphoonAssistedFactoryDefinition *(^TyphoonAssistedFactoryDefinitionProvider)(void);

/**
 * @see TyphoonAssistedFactoryCreatorForEachMethodInProtocol
 */
typedef void (^TyphoonAssistedFactoryCreatorMethodEnumeration)(struct objc_method_description methodDescription);

/**
 * @see TyphoonAssistedFactoryCreatorForEachPropertyInProtocol
 */
typedef void (^TyphoonAssistedFactoryCreatorPropertyEnumeration)(objc_property_t property);

/**
 * Returns the selector of the only possible factory method of the protocol.
 *
 * The protocol should only have one instance method, beside its property
 * getters. Otherwise this method behaviour is undefined.
 */
SEL TyphoonAssistedFactoryCreatorGuessFactoryMethodForProtocol(Protocol *protocol);

/**
 * Enumerates over all the methods in a class.
 */
void TyphoonAssistedFactoryCreatorForEachMethodInClass(Class klass, TyphoonAssistedFactoryCreatorMethodEnumeration enumerationBlock);

/**
 * Enumerates over all the methods in a protocol.
 */
void TyphoonAssistedFactoryCreatorForEachMethodInProtocol
    (Protocol *protocol, TyphoonAssistedFactoryCreatorMethodEnumeration enumerationBlock);

/**
 * Enumerates over all the properties in a protocol.
 */
void TyphoonAssistedFactoryCreatorForEachPropertyInProtocol
    (Protocol *protocol, TyphoonAssistedFactoryCreatorPropertyEnumeration enumerationBlock);


@interface TyphoonAssistedFactoryCreator ()
{
@protected
    Protocol *_protocol;
}

/**
 * Creates a new factory creator for the given protocol and the given lazy
 * factory definition.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol
    factoryDefinitionProvider:(TyphoonAssistedFactoryDefinitionProvider)definitionProvider;

@end
