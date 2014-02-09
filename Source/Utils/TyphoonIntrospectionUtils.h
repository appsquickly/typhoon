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
#import <objc/runtime.h>

@class TyphoonTypeDescriptor;

NSSet *TyphoonAutoWiredProperties(Class clazz, NSSet *properties);

NSString *TyphoonTypeStringFor(id classOrProtocol);


@interface TyphoonIntrospectionUtils : NSObject

+ (NSArray *)typeCodesForSelector:(SEL)selector ofClass:(Class)clazz isClassMethod:(BOOL)isClassMethod;

+ (TyphoonTypeDescriptor *)typeForPropertyWithName:(NSString *)propertyName inClass:(Class)clazz;

@end
