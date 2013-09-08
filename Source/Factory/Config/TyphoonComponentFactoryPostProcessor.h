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
 Allows for custom modification of a component factory's definitions.
 
 Component factories can auto-detect TyphoonComponentFactoryPostProcessor components in their definitions and apply them before any other components get created.
 
 @see TyphoonPropertyPlaceholderConfigurer for an example implementation.
 */
@protocol TyphoonComponentFactoryPostProcessor <NSObject>

/**
 Post process a component factory after its initialization.
 @param factory The component factory
 */
- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory;

@end
