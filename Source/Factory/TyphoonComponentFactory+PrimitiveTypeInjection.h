////////////////////////////////////////////////////////////////////////////////
//
//  MOD PRODUCTIONS
//  Copyright 2013 Mod Productions
//  All Rights Reserved.
//
//  NOTICE: Mod Productions permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactory.h"

@protocol TyphoonIntrospectiveNSObject;
@protocol TyphoonInjectedProperty;
@class TyphoonPropertyInjectedByValue;
@class TyphoonTypeDescriptor;
@class TyphoonParameterInjectedByValue;

@interface TyphoonComponentFactory (PrimitiveTypeInjection)

- (void)setPrimitiveArgumentFor:(NSInvocation*)invocation parameter:(TyphoonParameterInjectedByValue*)parameter
        requiredType:(TyphoonTypeDescriptor*)requiredType;

- (void)injectPrimitivePropertyValueOn:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonInjectedProperty>)property
        valueProperty:(TyphoonPropertyInjectedByValue*)parameter requiredType:(TyphoonTypeDescriptor*)requiredType;

@end