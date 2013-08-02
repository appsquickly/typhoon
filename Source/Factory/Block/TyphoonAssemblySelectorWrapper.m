//
//  AssemblyMethodSelectorToKeyConverter.m
//  Static Library
//
//  Created by Robert Gilliam on 7/29/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonAssemblySelectorWrapper.h"



static NSString* const TYPHOON_BEFORE_ADVICE_PREFIX = @"__typhoonBeforeAdvice__";



@implementation TyphoonAssemblySelectorWrapper

+ (SEL)wrappedSELForKey:(NSString *)key;
{
    return NSSelectorFromString([TYPHOON_BEFORE_ADVICE_PREFIX stringByAppendingString:key]);
}

+ (NSString *)keyForSEL:(SEL)unwrappedSEL;
{
    return NSStringFromSelector(unwrappedSEL);
}

+ (NSString *)keyForWrappedSEL:(SEL)selWithAdvicePrefix;
{
    NSString* name = NSStringFromSelector(selWithAdvicePrefix);
    NSString* key = [name stringByReplacingOccurrencesOfString:TYPHOON_BEFORE_ADVICE_PREFIX withString:@""];
    return key;
}

+ (BOOL)selectorIsWrapped:(SEL)sel;
{
    NSString* name = NSStringFromSelector(sel);
    return [name hasPrefix:TYPHOON_BEFORE_ADVICE_PREFIX];
}

+ (SEL)wrappedSELForSEL:(SEL)unwrappedSEL;
{
    return [self wrappedSELForKey:[self keyForSEL:unwrappedSEL]];
}

@end
