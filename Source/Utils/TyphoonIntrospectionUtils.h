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

static NSSet* TyphoonAutoInjectedProperties(Class clazz, NSSet* properties)
{
    Class superClass = class_getSuperclass([clazz class]);
    if ([superClass respondsToSelector:@selector(typhoonAutoInjectedProperties)])
    {
        NSMutableSet* superAutoWired = [[superClass performSelector:@selector(typhoonAutoInjectedProperties)] mutableCopy];
        [superAutoWired unionSet:properties];
        return superAutoWired;
    }
    return properties;
}

@interface TyphoonIntrospectionUtils : NSObject

+ (NSArray*)typeCodesForSelector:(SEL)selector ofClass:(Class)clazz isClassMethod:(BOOL)isClassMethod;

@end