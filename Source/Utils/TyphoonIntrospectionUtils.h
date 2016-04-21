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
#import <objc/runtime.h>

@class TyphoonTypeDescriptor;

NSString *TyphoonTypeStringFor(id classOrProtocol);

Class TyphoonClassFromString(NSString *className);

BOOL IsClass(id classOrProtocol);
BOOL IsBlock(const char *objCType);
BOOL IsProtocol(id classOrProtocol);

@interface TyphoonIntrospectionUtils : NSObject

+ (TyphoonTypeDescriptor *)typeForPropertyNamed:(NSString *)propertyName inClass:(Class)clazz;

+ (SEL)setterForPropertyWithName:(NSString *)property inClass:(Class)clazz;

+ (SEL)getterForPropertyWithName:(NSString *)property inClass:(Class)clazz;

+ (NSMethodSignature *)methodSignatureWithArgumentsAndReturnValueAsObjectsFromSelector:(SEL)selector;

+ (NSUInteger)numberOfArgumentsInSelector:(SEL)selector;

+ (NSSet *)propertiesForClass:(Class)clazz upToParentClass:(Class)parent;

+ (NSSet *)methodsForClass:(Class)clazz upToParentClass:(Class)parent;

@end
