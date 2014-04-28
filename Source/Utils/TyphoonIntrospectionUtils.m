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
#import <objc/message.h>
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"

@implementation TyphoonIntrospectionUtils

+ (TyphoonTypeDescriptor *)typeForPropertyWithName:(NSString *)propertyName inClass:(Class)clazz
{
    TyphoonTypeDescriptor *typeDescriptor = nil;
    objc_property_t propertyReflection = class_getProperty(clazz, [propertyName UTF8String]);
    if (propertyReflection) {
        const char *attrs = property_getAttributes(propertyReflection);
        if (attrs == NULL) {
            return (NULL);
        }

        static char buffer[256];
        const char *e = strchr(attrs, ',');
        if (e == NULL) {
            return (NULL);
        }

        int len = (int) (e - attrs);
        memcpy( buffer, attrs, len );
        buffer[len] = '\0';

        NSString *typeCode = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
        typeDescriptor = [TyphoonTypeDescriptor descriptorWithTypeCode:typeCode];
    }
    return typeDescriptor;
}

+ (SEL)setterForPropertyWithName:(NSString *)propertyName inClass:(Class)clazz
{
    SEL setterSelector = nil;
    
    objc_property_t property = class_getProperty(clazz, [propertyName cStringUsingEncoding:NSASCIIStringEncoding]);
    if (property) {
        
        const char *attributes = property_getAttributes(property);
        
        NSString *attributesString = [NSString stringWithCString:attributes encoding:NSASCIIStringEncoding];
        
        if (![self isReadonlyPropertyWithAttributes:attributesString]) {
            NSString *selectorString = [self customSetterForPropertyWithAttributes:attributesString];
            if (!selectorString) {
                selectorString = [self defaultSetterForPropertyWithName:propertyName];
            }
            setterSelector = NSSelectorFromString(selectorString);
        }
    }

    return setterSelector;
}

+ (NSArray *)typeCodesForSelector:(SEL)selector ofClass:(Class)clazz isClassMethod:(BOOL)isClassMethod
{
    NSMutableArray *typeCodes = [[NSMutableArray alloc] init];

    Method method;
    if (isClassMethod) {
        method = class_getClassMethod(clazz, selector);
    }
    else {
        method = class_getInstanceMethod(clazz, selector);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);

    for (int i = 2; i < argumentCount; i++) {
        char typeInfo[100];
        method_getArgumentType(method, i, typeInfo, 100);
        [typeCodes addObject:[NSString stringWithUTF8String:typeInfo]];
    }
    return [typeCodes copy];
}

+ (NSMethodSignature *)methodSignatureWithArgumentsAndReturnValueAsObjectsFromSelector:(SEL)selector
{
    NSMutableString *signatureString = [[NSMutableString alloc] initWithFormat:@"%s%s%s", @encode(id), @encode(id), @encode(SEL)];
    NSUInteger argc = [self numberOfArgumentsInSelector:selector];
    for (NSInteger i = 0; i < argc; i++) {
        [signatureString appendString:[NSString stringWithCString:@encode(id) encoding:NSASCIIStringEncoding]];
    }
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:[signatureString cStringUsingEncoding:NSASCIIStringEncoding]];

    return signature;
}

+ (NSUInteger)numberOfArgumentsInSelector:(SEL)selector
{
    NSString *string = NSStringFromSelector(selector);
    uint count = 0;
    for (int i = 0; i < string.length; i++) {
        if ([string characterAtIndex:i] == ':') {
                    count++;
        }
    }
    return count;
}

+ (NSSet *)properiesForClass:(Class)clazz upToParentClass:(Class)parent
{
    NSMutableSet *propertyNames = [[NSMutableSet alloc] init];
    
    while (clazz != parent) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(clazz, &count);
        
        for (int propertyIndex = 0; propertyIndex < count; propertyIndex++) {
            objc_property_t aProperty = properties[propertyIndex];
            NSString *propertyName = [NSString stringWithCString:property_getName(aProperty) encoding:NSUTF8StringEncoding];
            [propertyNames addObject:propertyName];
        }
        
        clazz = class_getSuperclass(clazz);
        
        free(properties);
    }
    
    return propertyNames;
}

+ (NSSet *)properiesForClass:(Class)clazz
{
    return [self properiesForClass:clazz upToParentClass:[NSObject class]];
}

#pragma mark - Utils

+ (BOOL)isReadonlyPropertyWithAttributes:(NSString *)attributes
{
    return [attributes rangeOfString:@",R,"].location != NSNotFound;
}

+ (NSString *)customSetterForPropertyWithAttributes:(NSString *)attributes
{
    NSRange setterBeginningRange = [attributes rangeOfString:@",S"];
    
    if (setterBeginningRange.location == NSNotFound)
        return nil;
    
    NSRange setterRange;
    setterRange.location = setterBeginningRange.location + setterBeginningRange.length;
    
    NSInteger endLocation = [attributes length];
    
    NSRange setterEndingRange = [attributes rangeOfString:@"," options:0 range:NSMakeRange(setterRange.location, [attributes length] - setterRange.location)];
    
    if (setterEndingRange.location != NSNotFound) {
        endLocation = setterEndingRange.location;
    }
    
    setterRange.length = endLocation - setterRange.location;
    
    return [attributes substringWithRange:setterRange];
}

+ (NSString *)defaultSetterForPropertyWithName:(NSString *)propertyName
{
    NSString *firstLetterUppercase = [[propertyName substringToIndex:1] uppercaseString];
    NSString *propertyPart = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetterUppercase];
    return [NSString stringWithFormat:@"set%@:", propertyPart];
}

@end

NSSet *TyphoonAutoWiredProperties(Class clazz, NSSet *properties) {
    Class superClass = class_getSuperclass([clazz class]);
    SEL autoInjectedProperties = sel_registerName("typhoonAutoInjectedProperties");
    if ([superClass respondsToSelector:autoInjectedProperties]) {
        NSMutableSet *superAutoWired = [objc_msgSend(superClass, autoInjectedProperties) mutableCopy];
        [superAutoWired unionSet:properties];
        return superAutoWired;
    }
    return properties;
}


NSString *TyphoonTypeStringFor(id classOrProtocol) {
    if (class_isMetaClass(object_getClass(classOrProtocol))) {
        return NSStringFromClass(classOrProtocol);
    }
    else {
        return [NSString stringWithFormat:@"id<%@>", NSStringFromProtocol(classOrProtocol)];
    }
}
