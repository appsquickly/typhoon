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

#import "NSObject+PropertyInjection.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonStringUtils.h"
#import <objc/message.h>

@implementation NSObject (PropertyInjection)

- (SEL)setterForPropertyName:(NSString *)propertyName
{
    NSString *firstLetterUppercase = [[propertyName substringToIndex:1] uppercaseString];
    NSString *propertyPart = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetterUppercase];
    NSString *selectorName = [NSString stringWithFormat:@"set%@:", propertyPart];
    return NSSelectorFromString(selectorName);
}

- (BOOL)isPointerValue:(id)value
{
    return CStringEquals([value objCType], @encode(void *));
}

- (void)injectValue:(id)value forPropertyName:(NSString *)propertyName withType:(TyphoonTypeDescriptor *)type
{
    if (type.isPrimitive && [value isKindOfClass:[NSValue class]] && [self isPointerValue:value]) {
        [self injectValue:value asPointerForPropertyName:propertyName];
    }
    else {
        [self setValue:value forKey:propertyName];
    }
}

- (void)injectValue:(NSValue *)value asPointerForPropertyName:(NSString *)propertyName
{
    SEL setterSelector = [self setterForPropertyName:propertyName];

    void *pointer;
    [value getValue:&pointer];

    objc_msgSend(self, setterSelector, pointer);
}

@end
