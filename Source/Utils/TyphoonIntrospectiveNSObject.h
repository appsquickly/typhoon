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

@class TyphoonTypeDescriptor;

@protocol TyphoonIntrospectiveNSObject <NSObject>

@property(nonatomic, strong, readonly) NSMutableDictionary* circularDependentProperties;

- (TyphoonTypeDescriptor*)typeForPropertyWithName:(NSString*)propertyName;

- (SEL)setterForPropertyWithName:(NSString*)propertyName;

@end