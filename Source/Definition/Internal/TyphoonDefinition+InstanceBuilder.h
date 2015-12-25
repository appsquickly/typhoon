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
#import "TyphoonDefinition.h"
#import "TyphoonInjectionEnumeration.h"

@protocol TyphoonPropertyInjection;
@protocol TyphoonInjection;
@class TyphoonComponentFactory;
@class TyphoonRuntimeArguments;

@interface TyphoonDefinition (InstanceBuilder) <TyphoonInjectionEnumeration>

- (TyphoonMethod *)beforeInjections;

- (NSOrderedSet *)injectedProperties;

- (NSOrderedSet *)injectedMethods;

- (TyphoonMethod *)afterInjections;

- (BOOL)hasRuntimeArgumentInjections;

- (void)addInjectedProperty:(id <TyphoonPropertyInjection>)property;

- (void)addInjectedPropertyIfNotExists:(id <TyphoonPropertyInjection>)property;

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args;

@end
