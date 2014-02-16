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


static NSString *const TYPHOON_BEFORE_ADVICE_PREFIX = @"__typhoonBeforeAdvice__";


/**
* Used to apply an aspect to TyphoonAssembly methods. Before invoking the original target we re-route to a cache to check if there is a
* value there. This is used to populate a component factory with definitions containing unique keys, where the unique key is the selector
* name on the TyphoonAssembly.
*/
@implementation TyphoonAssemblySelectorAdviser

+ (SEL)advisedSELForKey:(NSString *)key
{
    if ([key hasPrefix:TYPHOON_BEFORE_ADVICE_PREFIX]) {
        [NSException raise:NSInternalInconsistencyException format:@"Don't pass an advised key into a method expecting an unadvised key."];
    }

    return NSSelectorFromString([TYPHOON_BEFORE_ADVICE_PREFIX stringByAppendingString:key]);
}

+ (NSString *)keyForAdvisedSEL:(SEL)advisedSEL
{
    NSString *name = NSStringFromSelector(advisedSEL);
    NSString *key = [name stringByReplacingOccurrencesOfString:TYPHOON_BEFORE_ADVICE_PREFIX withString:@""];
    return key;
}

+ (NSString *)keyForSEL:(SEL)sel
{
    return NSStringFromSelector(sel);
}

+ (BOOL)selectorIsAdvised:(SEL)sel
{
    NSString *name = NSStringFromSelector(sel);
    return [name hasPrefix:TYPHOON_BEFORE_ADVICE_PREFIX];
}

+ (SEL)advisedSELForSEL:(SEL)sel
{
    return [self advisedSELForKey:[self keyForSEL:sel]];
}

+ (NSString *)advisedNameForName:(NSString *)string
{
    return NSStringFromSelector([self advisedSELForKey:string]);
}
@end
