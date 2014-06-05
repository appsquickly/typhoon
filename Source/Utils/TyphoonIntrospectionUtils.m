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
    objc_property_t propertyReflection = class_getProperty(clazz, [propertyName cStringUsingEncoding:NSASCIIStringEncoding]);
    if (propertyReflection) {
        const char *attributes = property_getAttributes(propertyReflection);

        if (attributes == NULL) {
            return (NULL);
        }

        static char buffer[256];
        const char *e = strchr(attributes, ',');
        if (e == NULL) {
            return (NULL);
        }

        int len = (int) (e - attributes);
        memcpy( buffer, attributes, len );
        buffer[len] = '\0';

        NSString *typeCode = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
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
    else if (propertyName.length > 0) {
        NSString *selectorString = [self defaultSetterForPropertyWithName:propertyName];
        SEL aSelector = NSSelectorFromString(selectorString);
        if (class_getInstanceMethod(clazz, aSelector)) {
            setterSelector = aSelector;
        }
    }

    return setterSelector;
}

+ (NSMethodSignature *)methodSignatureWithArgumentsAndReturnValueAsObjectsFromSelector:(SEL)selector
{
    NSUInteger argc = [self numberOfArgumentsInSelector:selector];
    NSMutableString *signatureString = [[NSMutableString alloc] initWithCapacity:argc + 3]; //one symbol per encoded type
    [signatureString appendFormat:@"%s%s%s", @encode(id), @encode(id), @encode(SEL)];
    for (NSUInteger i = 0; i < argc; i++) {
        [signatureString appendString:[NSString stringWithCString:@encode(id) encoding:NSASCIIStringEncoding]];
    }
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:[signatureString cStringUsingEncoding:NSASCIIStringEncoding]];

    return signature;
}

+ (NSUInteger)numberOfArgumentsInSelector:(SEL)selector
{
    NSString *string = NSStringFromSelector(selector);
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < string.length; i++) {
        if ([string characterAtIndex:i] == ':') {
            count++;
        }
    }
    return count;
}

+ (NSSet *)propertiesForClass:(Class)clazz upToParentClass:(Class)parent
{
    NSMutableSet *propertyNames = [[NSMutableSet alloc] init];
    
    while (clazz != parent) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(clazz, &count);
        
        for (unsigned int propertyIndex = 0; propertyIndex < count; propertyIndex++) {
            objc_property_t aProperty = properties[propertyIndex];
            NSString *propertyName = [NSString stringWithCString:property_getName(aProperty) encoding:NSUTF8StringEncoding];
            [propertyNames addObject:propertyName];
        }
        
        clazz = class_getSuperclass(clazz);
        
        free(properties);
    }
    
    return propertyNames;
}

+ (NSSet *)propertiesForClass:(Class)clazz
{
    return [self propertiesForClass:clazz upToParentClass:[NSObject class]];
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
    
    NSUInteger endLocation = [attributes length];
    
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
