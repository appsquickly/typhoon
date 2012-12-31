////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "RXMLElement.h"

@class SpringComponentDefinition;
@protocol SpringInjectedProperty;
@class SpringComponentInitializer;
@protocol SpringInjectedParameter;

@interface RXMLElement (SpringXmlComponentFactory)

- (SpringComponentDefinition*)asComponentDefinition;

- (id<SpringInjectedProperty>)asInjectedProperty;

- (SpringComponentInitializer*)asInitializer;



@end