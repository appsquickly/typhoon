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

#import "TyphoonDefinition.h"
#import "TyphoonAssistedFactoryDefinition.h"

/**
* \ingroup Factory
*
* Provides a factory that combines the convenience method arguments with the assembly-supplied dependencies to construct objects.
*
* To create a factory you must define a protocol for the factory, wire its dependencies (defined as readonly properties), and, sometimes,
* provide implementation blocks or initializer descriptions for the body of the class methods. Most of the simplest cases should be covered
* with no glue code, and the rest of them, with a couple of lines.
*
* Known limitation: You can only create one factory for a given protocol.
*/
@interface TyphoonFactoryProvider : NSObject

/**
 * Creates a factory definition for a given protocol, dependencies and factory block. The protocol is supposed to only have one factory
 * method, otherwise this method will fail during runtime.
*/
+ (TyphoonDefinition*)withProtocol:(Protocol*)protocol
        dependencies:(TyphoonDefinitionBlock)dependenciesBlock
        factory:(id)factoryBlock;

/**
 * Creates a factory definition for a given protocol, dependencies, and return type. The protocol is supposed to only have one factory
 * method, otherwise this method will fail during runtime.
 *
 * The factory method will invoke one of the initializer methods of the returnType. To determine which initializer method will be used, the
 * atoms of the factory method and the init method will be matched, filling up missing parameters with the properties present in the
 * protocol. Ties will be resolved choosing the init method with most factory method argument used, and the arbitrarily. If no valid init
 * method is found, the invocation will fail during runtime.
 *
 * For this method to work the names of the factory methods and the init method should follow some common rules:
 *
 * - The init method name should start with `initWith`.
 * - The factory method name should have `With` between the return type and the argument "names".
 * - All argument "names" are transformed to be "camelCase" (first letter will always be lowercase).
 * - Property names should be "camelCase".
 * - No "and" between argument "names".
 *
 * Initializers and factory methods like the following follow the rules:
 *
 * - initWithName:, initWithName:age:gender:, initWithDate:amount:
 * - personWithName:, personWithName:age:gender:, paymentWithDate:amount:
 *
 * While names like the following will not work:
 *
 * - initFromFile:, initWithX:andY:
 * - personNamed:age:gender:
 *
 * If your init method or your factory method could not follow the rules (or you don't want them to follow the rules) you should use one of
 * the other methods and provide the implementation block yourself.
*/
+ (TyphoonDefinition*)withProtocol:(Protocol*)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock returns:(Class)returnType;

/**
 * Creates a factor definition for a given protocol, dependencies and a list of factory methods. The protocol is supposed to have the same
 * number of class methods, and with the same selectors as defined in the factories block, otherwise this method will fail during runtime.
*/
+ (TyphoonDefinition*)withProtocol:(Protocol*)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock
        factories:(TyphoonAssistedFactoryDefinitionBlock)definitionBlock;

@end
