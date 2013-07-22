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
#import "TyphoonDefinition.h"

@protocol TyphoonInjectedProperty;
@class TyphoonInitializer;
@protocol TyphoonInjectedParameter;

@interface TyphoonRXMLElement (XmlComponentFactory)
@property (nonatomic, assign) TyphoonScope defaultScope;

- (TyphoonDefinition*)asComponentDefinition;

- (id<TyphoonInjectedProperty>)asInjectedProperty;

- (TyphoonInitializer*)asInitializer;



@end