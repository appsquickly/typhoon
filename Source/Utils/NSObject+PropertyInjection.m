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
#import <objc/message.h>

@implementation NSObject (PropertyInjection)

- (BOOL) isValue:(NSValue *)value withObjcType:(const char *)type
{
    const char *valueType = [value objCType];
    return valueType == type || strcmp(valueType, type) == 0;
}

- (SEL) setterForPropertyName:(NSString *)propertyName
{
    NSString* firstLetterUppercase = [[propertyName substringToIndex:1] uppercaseString];
    NSString* propertyPart = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetterUppercase];
    NSString* selectorName = [NSString stringWithFormat:@"set%@:", propertyPart];
    return NSSelectorFromString(selectorName);
}

- (void) injectValue:(id)value forPropertyName:(NSString *)propertyName
{
    BOOL isSupportKVC = YES;
    id valueToInject = value;
    
    /* Workaround for property types not supported by KVC */
    if ([value isKindOfClass:[NSValue class]]) {
        if ([self isValue:value withObjcType:@encode(SEL)]) {
            isSupportKVC = NO;
            [value getValue:&valueToInject];
        } else if ([self isValue:value withObjcType:@encode(const char *)]) {
            isSupportKVC = NO;
            [value getValue:&valueToInject];
        }
    }
    
    if (isSupportKVC) {
        [self setValue:valueToInject forKey:propertyName];
    } else {
        SEL setterSelector = [self setterForPropertyName:propertyName];
        objc_msgSend(self, setterSelector, valueToInject);
    }
}

@end
