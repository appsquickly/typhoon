////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonDefinitionBase.h"

@class TyphoonRuntimeArguments;
@class TyphoonComponentFactory;

/**
 * These methods must be implemented in TyphoonDefinitionBase subclasses.
 */
@interface TyphoonDefinitionBase (InstanceBuilder)

- (id)initializeInstanceWithArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory;

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory;

@end
