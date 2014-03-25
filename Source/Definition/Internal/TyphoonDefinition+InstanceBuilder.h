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

@protocol TyphoonPropertyInjection;

@interface TyphoonDefinition (InstanceBuilder)

- (void)setType:(Class)type;

- (NSSet *)componentsInjectedByValue;

- (NSSet *)propertiesInjectedByValue;

- (NSSet *)propertiesInjectedByType;

- (NSSet *)propertiesInjectedByObjectInstance;

- (NSSet *)propertiesInjectedByReference;

- (NSSet *)propertiesInjectedByRuntimeArgument;

- (id<TyphoonPropertyInjection>)propertyInjectionForProperty:(NSString *)property;

- (NSSet *)injectedProperties;

- (NSSet *)injectedMethods;

- (void)addInjectedProperty:(id <TyphoonPropertyInjection>)property;

- (void)removeInjectedProperty:(id <TyphoonPropertyInjection>)property;

@end
