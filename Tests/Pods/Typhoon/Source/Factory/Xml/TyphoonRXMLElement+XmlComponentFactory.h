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

@class TyphoonDefinition;
@protocol TyphoonInjectedProperty;
@class TyphoonInitializer;
@protocol TyphoonInjectedParameter;

@interface TyphoonRXMLElement (XmlComponentFactory)

- (TyphoonDefinition*)asComponentDefinition;

- (id<TyphoonInjectedProperty>)asInjectedProperty;

- (TyphoonInitializer*)asInitializer;



@end