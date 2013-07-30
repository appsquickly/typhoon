//
//  AssemblyMethodSelectorToKeyConverter.m
//  Static Library
//
//  Created by Robert Gilliam on 7/29/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonAssemblySelectorWrapper.h"



static NSString* const TYPHOON_BEFORE_ADVICE_SUFFIX = @"__typhoonBeforeAdvice";



@implementation TyphoonAssemblySelectorWrapper

+ (SEL)wrappedSELForKey:(NSString *)key;
{
    return NSSelectorFromString([key stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX]);
}

+ (NSString *)keyForWrappedSEL:(SEL)selWithAdvicePrefix;
{
    NSString* name = NSStringFromSelector(selWithAdvicePrefix);
    NSString* key = [name stringByReplacingOccurrencesOfString:TYPHOON_BEFORE_ADVICE_SUFFIX withString:@""];
    return key;
}

+ (BOOL)selectorIsWrapped:(SEL)sel;
{
    NSString* name = NSStringFromSelector(sel);
    return [name hasSuffix:TYPHOON_BEFORE_ADVICE_SUFFIX];  // a name will always have this suffix after a TyphoonBlockComponentFactory has been initialized with us as the assembly. Make this clearer. All user facing calls will always go through the dynamic implementation machinery.
}

+ (SEL)wrappedSELForSEL:(SEL)unwrappedSEL;
{
    return NSSelectorFromString([NSStringFromSelector(unwrappedSEL) stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX]);
}

@end
