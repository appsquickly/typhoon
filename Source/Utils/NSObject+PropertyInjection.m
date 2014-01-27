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


- (BOOL) isKvcSupportUnboxingForValue:(id)value
{
    BOOL isUnsupportedType = NO;
    
    int count = 3;
    const char* unsupportedTypes[3] = {@encode(SEL), @encode(const char *), @encode(void *)};
    
    for (int i = 0; i < count; i++) {
        if ([self isValue:value withObjcType:unsupportedTypes[i]]) {
            isUnsupportedType = YES;
            break;
        }
    }
    
    return !isUnsupportedType;
}

- (void) injectValue:(id)value forPropertyName:(NSString *)propertyName withType:(TyphoonTypeDescriptor *)type
{
    BOOL shouldInjectByKVC = YES;
    
    if (type.isPrimitive && [value isKindOfClass:[NSValue class]] && ![self isKvcSupportUnboxingForValue:value]) {
        [self injectValue:value asPointerForPropertyName:propertyName];
    } else {
        [self setValue:value forKey:propertyName];
    }
}

- (void) injectValue:(NSValue *)value asPointerForPropertyName:(NSString *)propertyName
{
    SEL setterSelector = [self setterForPropertyName:propertyName];
    
    void* pointer;
    [value getValue:&pointer];
    
    objc_msgSend(self, setterSelector, pointer);
}

@end
