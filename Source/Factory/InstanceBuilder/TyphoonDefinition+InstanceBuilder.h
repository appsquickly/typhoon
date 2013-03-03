////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "TyphoonDefinition.h"

@interface TyphoonDefinition (InstanceBuilder)

- (void)injectProperty:(SEL)withSelector withReference:(NSString*)reference;

- (NSSet*)propertiesInjectedByValue;

- (NSSet*)propertiesInjectedByType;

- (NSSet*)propertiesInjectedByReference;

@end