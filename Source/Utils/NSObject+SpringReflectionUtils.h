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
#import "SpringReflectiveNSObject.h"

@class SpringTypeDescriptor;

@interface NSObject (SpringReflectionUtils) <SpringReflectiveNSObject>

/**
* Returns a Class object or `SpringTypeDescriptor` in the case of a primitive type.
*/
- (SpringTypeDescriptor*)typeForPropertyWithName:(NSString*)propertyName;

- (SEL)setterForPropertyWithName:(NSString*)propertyName;

- (NSArray*)parameterNamesForSelector:(SEL)selector;

- (NSArray*)typeCodesForSelector:(SEL)selector;

@end