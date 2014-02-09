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
#import "TyphoonIntrospectiveNSObject.h"

@class TyphoonTypeDescriptor;

@interface NSObject (TyphoonIntrospectionUtils) <TyphoonIntrospectiveNSObject>

@property(nonatomic, strong, readonly) NSMutableDictionary *circularDependentProperties;

/**
* Returns a Class object or `TyphoonTypeDescriptor` in the case of a primitive type.
*/
- (TyphoonTypeDescriptor *)typeForPropertyWithName:(NSString *)propertyName;

- (NSArray *)parameterNamesForSelector:(SEL)selector;

- (NSArray *)typeCodesForSelector:(SEL)selector;

- (NSArray *)typeCodesForSelector:(SEL)selector onClass:(Class)class;


@end
