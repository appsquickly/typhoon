////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////




#import <Foundation/Foundation.h>

@class TyphoonTypeDescriptor;

@interface NSObject (TyphoonIntrospectionUtils)

/**
* Returns a set of property names up to the parent class.
*/
- (NSSet*) /* <NSString> */ typhoonPropertiesUpToParentClass:(Class)clazz;

/**
* Returns a Class object or `TyphoonTypeDescriptor` in the case of a primitive type.
*/
- (TyphoonTypeDescriptor *)typhoonTypeForPropertyNamed:(NSString *)propertyName;

@end
