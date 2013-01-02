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




#import <objc/runtime.h>
#import "SpringReflectionUtils.h"


@implementation SpringReflectionUtils

+ (NSArray*)typeCodesForSelector:(SEL)selector ofClass:(Class)clazz isClassMethod:(BOOL)isClassMethod
{
    NSMutableArray* typeCodes = [[NSMutableArray alloc] init];

    Method method;
    if (isClassMethod)
    {
        method = class_getClassMethod(clazz, selector);
    }
    else
    {
        method = class_getInstanceMethod(clazz, selector);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);

    for (int i = 2; i < argumentCount; i++)
    {
        char typeInfo[100];
        method_getArgumentType(method, i, typeInfo, 100);
        [typeCodes addObject:[NSString stringWithUTF8String:typeInfo]];
    }
    return [typeCodes copy];
}


@end