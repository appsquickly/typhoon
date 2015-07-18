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

#import "TyphoonAssemblySelectorAdviser.h"


static NSString *const TYPHOON_BEFORE_ADVICE_SUFFIX = @"__typhoonBeforeAdvice__";


/**
* Used to apply an aspect to TyphoonAssembly methods. Before invoking the original target we re-route to a cache to check if there is a
* value there. This is used to populate a component factory with definitions containing unique keys, where the unique key is the selector
* name on the TyphoonAssembly.
*/
@implementation TyphoonAssemblySelectorAdviser

+ (NSString *)prefixForClass:(Class)clazz
{
    return [NSStringFromClass(clazz) stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX];
}

+ (SEL)advisedSELForKey:(NSString *)key class:(Class)clazz
{
    if ([key rangeOfString:TYPHOON_BEFORE_ADVICE_SUFFIX].location != NSNotFound) {
        [NSException raise:NSInternalInconsistencyException format:@"Don't pass an advised key into a method expecting an unadvised key."];
    }

    return NSSelectorFromString([[self prefixForClass:clazz] stringByAppendingString:key]);
}

+ (NSString *)keyForAdvisedSEL:(SEL)advisedSEL
{
    NSString *name = NSStringFromSelector(advisedSEL);

    NSString *key = name;

    NSRange suffixRange = [name rangeOfString:TYPHOON_BEFORE_ADVICE_SUFFIX];
    if (suffixRange.location != NSNotFound) {
        key = [name substringFromIndex:NSMaxRange(suffixRange)];
    }

    return key;
}

+ (NSString *)keyForSEL:(SEL)sel
{
    return NSStringFromSelector(sel);
}

+ (BOOL)selectorIsAdvised:(SEL)sel
{
    NSString *name = NSStringFromSelector(sel);
    return [name rangeOfString:TYPHOON_BEFORE_ADVICE_SUFFIX].location != NSNotFound;
}

+ (SEL)advisedSELForSEL:(SEL)sel class:(Class)clazz
{
    return [self advisedSELForKey:[self keyForSEL:sel] class:clazz];
}

+ (NSString *)advisedNameForName:(NSString *)string class:(Class)clazz
{
    return NSStringFromSelector([self advisedSELForKey:string class:clazz]);
}
@end
