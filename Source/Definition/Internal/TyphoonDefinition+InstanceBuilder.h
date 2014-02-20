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

@class TyphoonAbstractInjectedProperty;

@interface TyphoonDefinition (InstanceBuilder)

- (void)setType:(Class)type;

- (NSSet *)componentsInjectedByValue;

- (void)injectProperty:(SEL)withSelector withReference:(NSString *)reference;

- (NSSet *)propertiesInjectedByValue;

- (NSSet *)propertiesInjectedByType;

- (NSSet *)propertiesInjectedByReference;

- (void)addInjectedProperty:(TyphoonAbstractInjectedProperty *)property;

- (void)removeInjectedProperty:(TyphoonAbstractInjectedProperty *)property;

@end
