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
#import <objc/runtime.h>

NSSet* TyphoonAutoWiredProperties(Class clazz, NSSet* properties);

NSString* TyphoonTypeStringFor(id classOrProtocol);


@interface TyphoonIntrospectionUtils : NSObject

+ (NSArray*)typeCodesForSelector:(SEL)selector ofClass:(Class)clazz isClassMethod:(BOOL)isClassMethod;

@end