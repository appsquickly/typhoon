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
@interface TyphoonComponentFactory (InstanceBuilder)

- (id)buildInstanceWithDefinition:(TyphoonDefinition*)definition;

- (void)injectPropertyDependenciesOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition;

- (NSArray*)allDefinitionsForType:(id)classOrProtocol;

- (TyphoonDefinition*)definitionForType:(id)classOrProtocol;

@end