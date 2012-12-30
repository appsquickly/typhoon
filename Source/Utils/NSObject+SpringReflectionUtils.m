////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <objc/runtime.h>
#import "SpringTypeDescriptor.h"


@implementation NSObject (SpringReflectionUtils)

- (SpringTypeDescriptor*)typeForPropertyWithName:(NSString*)propertyName;
{
    SpringTypeDescriptor* typeDescriptor = nil;
    objc_property_t propertyReflection = class_getProperty([self class], [propertyName UTF8String]);
    if (propertyReflection)
    {
        const char* attrs = property_getAttributes(propertyReflection);
        if (attrs == NULL)
        {
            return (NULL);
        }

        static char buffer[256];
        const char* e = strchr(attrs, ',');
        if (e == NULL)
        {
            return (NULL);
        }

        int len = (int) (e - attrs);
        memcpy( buffer, attrs, len );
        buffer[len] = '\0';

        typeDescriptor = [SpringTypeDescriptor descriptorWithTypeCode:[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding]];
    }
    return typeDescriptor;
}

- (SEL)setterForPropertyWithName:(NSString*)propertyName
{
    NSString* firstLetterUppercase = [[propertyName substringToIndex:1] uppercaseString];
    NSString* propertyPart = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetterUppercase];
    NSString* selectorName = [NSString stringWithFormat:@"set%@:", propertyPart];
    SEL selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector])
    {
        return selector;
    }
    return nil;
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
    NSMutableArray* typeCodes = [[NSMutableArray alloc] init];

    Method method = class_getInstanceMethod([self class], selector);
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