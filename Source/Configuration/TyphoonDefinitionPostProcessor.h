////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class TyphoonComponentFactory;
@class TyphoonDefinition;

/**
* @ingroup Assembly
*
 Allows for custom modification of a component factory's definitions.
 
 Component factories can auto-detect TyphoonComponentFactoryPostProcessor components in their definitions and apply them before any other
 components get created.
 
 @see TyphoonConfigPostProcessor for an example implementation.
 @see TyphoonComponentPostProcessor which modifies instances after they've been built, rather than the definitions
 */
@protocol TyphoonDefinitionPostProcessor <NSObject>

/**
 Post process a definition.

 Called for each definition in the factory. You able to modify definition and you can return another definition, using definitionToReplace pointer.

 @param definition The definition.
 @param definitionToReplace pointer to definition replacement
 @param factory The component factory.
 */
- (void)postProcessDefinition:(TyphoonDefinition *)definition replacement:(TyphoonDefinition **)definitionToReplace withFactory:(TyphoonComponentFactory *)factory;

@end
