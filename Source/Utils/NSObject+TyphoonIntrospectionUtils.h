////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
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
* Returns a Class object or `TyphoonTypeDescriptor` in the case of a primitive type.
*/
- (TyphoonTypeDescriptor *)typhoon_typeForPropertyWithName:(NSString *)propertyName;

- (NSArray *)typhoon_parameterNamesForSelector:(SEL)selector;

@end
