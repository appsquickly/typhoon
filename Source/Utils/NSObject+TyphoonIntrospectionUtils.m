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


@implementation NSObject (TyphoonIntrospectionUtils)

- (TyphoonTypeDescriptor *)typhoon_typeForPropertyWithName:(NSString *)propertyName
{
    return [TyphoonIntrospectionUtils typeForPropertyWithName:propertyName inClass:[self class]];
}

- (NSArray *)typhoon_parameterNamesForSelector:(SEL)selector
{
    NSUInteger parametersCount = [TyphoonIntrospectionUtils numberOfArgumentsInSelector:selector];

    if (parametersCount == 0) {
        return @[];
    }

    NSMutableArray *parameterNames = [[NSMutableArray alloc] initWithCapacity:parametersCount];
    NSArray *parameters = [NSStringFromSelector(selector) componentsSeparatedByString:@":"];
    for (NSUInteger i = 0; i < [parameters count]; i++) {
        NSString *parameterName = [parameters objectAtIndex:i];
        if (i == 0) {
            parameterName = [[parameterName componentsSeparatedByString:@"With"] lastObject];
        }
        if ([parameterName length] > 0) {
            parameterName = [self stringByLowerCasingFirstLetter:parameterName];
            [parameterNames addObject:parameterName];
        }
    }
    return parameterNames;
}

- (NSString *)stringByLowerCasingFirstLetter:(NSString *)name
{
    return [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[name substringToIndex:1] lowercaseString]];
}

@end
