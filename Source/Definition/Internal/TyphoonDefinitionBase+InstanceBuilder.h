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

@interface TyphoonDefinitionBase (InstanceBuilder)

- (id)initializeInstanceWithArgs:(TyphoonRuntimeArguments *)args;

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args;

@end
