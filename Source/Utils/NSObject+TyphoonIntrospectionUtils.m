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




#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(NSObject_TyphoonIntrospectionUtils)

#import <objc/runtime.h>
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonStringUtils.h"


static char const *const CIRCULAR_DEPENDENCIES_KEY = "typhoon.injectLater";

@implementation NSObject (TyphoonIntrospectionUtils)

- (TyphoonTypeDescriptor *)typeForPropertyWithName:(NSString *)propertyName;
{
    return [TyphoonIntrospectionUtils typeForPropertyWithName:propertyName inClass:[self class]];
}

- (NSArray *)parameterNamesForSelector:(SEL)selector
{
    if (![TyphoonStringUtils string:NSStringFromSelector(selector) containsString:@":"]) {
        return @[];
    }

    NSMutableArray *parameterNames = [[NSMutableArray alloc] init];
    NSArray *parameters = [NSStringFromSelector(selector) componentsSeparatedByString:@":"];
    for (int i = 0; i < [parameters count]; i++) {
        NSString *parameterName = [parameters objectAtIndex:i];
        if (i == 0) {
            parameterName = [[parameterName componentsSeparatedByString:@"With"] lastObject];
        }
        if ([parameterName length] > 0) {
            parameterName = [self stringByLowerCasingFirstLetter:parameterName];
            [parameterNames addObject:parameterName];
        }
    }
    return [parameterNames copy];
}

- (NSString *)stringByLowerCasingFirstLetter:(NSString *)name
{
    return [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[name substringToIndex:1] lowercaseString]];
}

- (NSArray *)typeCodesForSelector:(SEL)selector
{
    return [TyphoonIntrospectionUtils typeCodesForSelector:selector ofClass:[self class] isClassMethod:NO];
}

- (NSMutableDictionary *)circularDependentProperties
{
    NSMutableDictionary *circularDependentProperties = objc_getAssociatedObject(self, &CIRCULAR_DEPENDENCIES_KEY);
    if (circularDependentProperties == nil) {
        circularDependentProperties = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &CIRCULAR_DEPENDENCIES_KEY, circularDependentProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return circularDependentProperties;
}


@end
