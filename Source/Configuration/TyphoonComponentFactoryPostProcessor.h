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

@class TyphoonComponentFactory;

/**
* @ingroup Factory
*
 Allows for custom modification of a component factory's definitions.
 
 Component factories can auto-detect TyphoonComponentFactoryPostProcessor components in their definitions and apply them before any other
 components get created.
 
 @see TyphoonConfigPostProcessor for an example implementation.
 @see TyphoonComponentPostProcessor which modifies instances after they've been built, rather than the definitions
 */
@protocol TyphoonComponentFactoryPostProcessor <NSObject>

/**
 Post process a component factory after its initialization.

 May be called more than once, if a PostProcessor is added to a ComponentFactory after a component has been retrieved from that factory.
 @param factory The component factory
 */
- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory;

@end
