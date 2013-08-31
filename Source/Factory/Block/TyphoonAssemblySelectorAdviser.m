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

#import "TyphoonAssemblySelectorAdviser.h"



static NSString* const TYPHOON_BEFORE_ADVICE_SUFFIX = @"__typhoonBeforeAdvice";



@implementation TyphoonAssemblySelectorAdviser

+ (SEL)advisedSELForKey:(NSString *)key;
{
    return NSSelectorFromString([key stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX]);
}

+ (NSString *)keyForAdvisedSEL:(SEL)selWithAdvicePrefix;
{
    NSString* name = NSStringFromSelector(selWithAdvicePrefix);
    NSString* key = [name stringByReplacingOccurrencesOfString:TYPHOON_BEFORE_ADVICE_SUFFIX withString:@""];
    return key;
}

+ (BOOL)selectorIsAdvised:(SEL)sel;
{
    NSString* name = NSStringFromSelector(sel);
    return [name hasSuffix:TYPHOON_BEFORE_ADVICE_SUFFIX];  // a name will always have this suffix after a TyphoonBlockComponentFactory has been initialized with us as the assembly. Make this clearer. All user facing calls will always go through the dynamic implementation machinery.
}

+ (SEL)advisedSELForSEL:(SEL)unwrappedSEL;
{
    return NSSelectorFromString([NSStringFromSelector(unwrappedSEL) stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX]);
}

@end
