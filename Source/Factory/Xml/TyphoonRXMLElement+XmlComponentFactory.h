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
#import "TyphoonRXMLElement.h"

@class TyphoonComponentDefinition;
@protocol TyphoonInjectedProperty;
@class TyphoonComponentInitializer;
@protocol TyphoonInjectedParameter;

@interface TyphoonRXMLElement (XmlComponentFactory)

- (TyphoonComponentDefinition*)asComponentDefinition;

- (id<TyphoonInjectedProperty>)asInjectedProperty;

- (TyphoonComponentInitializer*)asInitializer;



@end