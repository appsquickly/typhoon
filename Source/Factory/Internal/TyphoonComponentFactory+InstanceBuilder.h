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
#import "TyphoonComponentFactory.h"
#import "TyphoonIntrospectiveNSObject.h"
#import "TyphoonInjectedAsCollection.h"

@class TyphoonCallStack;

/**
* Encapsulates the methods related to assembling an instance using the Objective-C runtime. This is an internal category - the methods will
* not be required for normal use of Typhoon.
*/
@interface TyphoonComponentFactory (InstanceBuilder)

- (TyphoonCallStack *)stack;

- (id)buildInstanceWithDefinition:(TyphoonDefinition *)definition;

- (id)buildSharedInstanceForDefinition:(TyphoonDefinition *)definition;

- (void)doPropertyInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition;

- (NSArray *)allDefinitionsForType:(id)classOrProtocol;

- (TyphoonDefinition *)definitionForType:(id)classOrProtocol;

- (void)injectAssemblyOnInstanceIfTyphoonAware:(id)instance;

- (void)evaluateCircularDependency:(NSString *)componentKey propertyName:(NSString *)propertyName
    instance:(id <TyphoonIntrospectiveNSObject>)instance;

- (BOOL)propertyIsCircular:(TyphoonAbstractInjectedProperty *)property onInstance:(id <TyphoonIntrospectiveNSObject>)instance;

@end
