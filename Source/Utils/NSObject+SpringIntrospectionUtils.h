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
#import "SpringIntrospectiveNSObject.h"

@class SpringTypeDescriptor;

@interface NSObject (SpringIntrospectionUtils) <SpringIntrospectiveNSObject>

/**
* Returns a Class object or `SpringTypeDescriptor` in the case of a primitive type.
*/
- (SpringTypeDescriptor*)typeForPropertyWithName:(NSString*)propertyName;

- (SEL)setterForPropertyWithName:(NSString*)propertyName;

- (NSArray*)parameterNamesForSelector:(SEL)selector;

- (NSArray*)typeCodesForSelector:(SEL)selector;

- (NSArray*)typeCodesForSelector:(SEL)selector onClass:(Class)class;

@end