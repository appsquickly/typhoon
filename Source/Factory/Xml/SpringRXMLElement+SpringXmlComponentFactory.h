////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "SpringRXMLElement.h"

@class SpringComponentDefinition;
@protocol SpringInjectedProperty;
@class SpringComponentInitializer;
@protocol SpringInjectedParameter;

@interface SpringRXMLElement (SpringXmlComponentFactory)

- (SpringComponentDefinition*)asComponentDefinition;

- (id<SpringInjectedProperty>)asInjectedProperty;

- (SpringComponentInitializer*)asInitializer;



@end