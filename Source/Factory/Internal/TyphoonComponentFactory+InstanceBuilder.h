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

/**
* Encapsulates the methods related to assembling an instance using the Objective-C runtime. This is an internal category - the methods will
* not be required for normal use of Typhoon.
*/
@interface TyphoonComponentFactory (InstanceBuilder)

- (id)buildInstanceWithDefinition:(TyphoonDefinition*)definition NS_RETURNS_RETAINED;

- (id)buildSharedInstanceForDefinition:(TyphoonDefinition*)definition NS_RETURNS_RETAINED;

- (void)injectPropertyDependenciesOn:(__autoreleasing id)instance withDefinition:(TyphoonDefinition*)definition;

- (NSArray*)allDefinitionsForType:(id)classOrProtocol;

- (TyphoonDefinition*)definitionForType:(id)classOrProtocol;

@end
