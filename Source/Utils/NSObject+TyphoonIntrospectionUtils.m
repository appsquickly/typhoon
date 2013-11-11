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




#import <objc/runtime.h>
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"


static char const* const CIRCULAR_DEPENDENCIES_KEY = "typhoon.injectLater";

@implementation NSObject (TyphoonIntrospectionUtils)

- (TyphoonTypeDescriptor*)typeForPropertyWithName:(NSString*)propertyName;
{
    return [TyphoonIntrospectionUtils typeForPropertyWithName:propertyName inClass:[self class]];
}

- (SEL)setterForPropertyWithName:(NSString*)propertyName
{

    NSString* firstLetterUppercase = [[propertyName substringToIndex:1] uppercaseString];
    NSString* propertyPart = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetterUppercase];
    NSString* selectorName = [NSString stringWithFormat:@"set%@:", propertyPart];
    SEL selector = NSSelectorFromString(selectorName); //It's crashing here, not the next line.
    if (![self respondsToSelector:selector])
    {
        if ([self respondsToSelector:NSSelectorFromString(propertyName)])
        {
            [NSException raise:NSInvalidArgumentException format:@"Property '%@' of class '%@' is readonly.", propertyName, [self class]];
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"No setter named '%@' on class '%@'.", selectorName, [self class]];
        }
    }
    return selector;
}

- (NSArray*)parameterNamesForSelector:(SEL)selector
{
    NSMutableArray* parameterNames = [[NSMutableArray alloc] init];
    NSArray* parameters = [NSStringFromSelector(selector) componentsSeparatedByString:@":"];
    for (int i = 0; i < [parameters count]; i++)
    {
        NSString* parameterName = [parameters objectAtIndex:i];
        if (i == 0)
        {
            parameterName = [[parameterName componentsSeparatedByString:@"With"] lastObject];
        }
        if ([parameterName length] > 0)
        {
            parameterName = [parameterName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                    withString:[[parameterName substringToIndex:1] lowercaseString]];
            [parameterNames addObject:parameterName];
        }
    }
    return [parameterNames copy];
}

- (NSArray*)typeCodesForSelector:(SEL)selector
{
    return [TyphoonIntrospectionUtils typeCodesForSelector:selector ofClass:[self class] isClassMethod:NO];
}

- (NSMutableDictionary*)circularDependentProperties
{
    NSMutableDictionary* circularDependentProperties = objc_getAssociatedObject(self, &CIRCULAR_DEPENDENCIES_KEY);
    if (circularDependentProperties == nil)
    {
        circularDependentProperties = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &CIRCULAR_DEPENDENCIES_KEY, circularDependentProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return circularDependentProperties;
}


@end
