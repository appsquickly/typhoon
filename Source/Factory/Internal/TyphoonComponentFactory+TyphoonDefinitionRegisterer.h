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
#import "TyphoonComponentFactory.h"
#import "TyphoonRuntimeArguments.h"

@protocol TyphoonInstancePostProcessor;

@interface TyphoonComponentFactory (TyphoonDefinitionRegisterer)

- (TyphoonDefinition *)definitionForKey:(NSString *)key;

- (id)newOrScopeCachedInstanceForDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args;

- (void)addDefinitionToRegistry:(TyphoonDefinition *)definition;

- (void)addInstancePostProcessor:(id <TyphoonInstancePostProcessor>)postProcessor;

@end
