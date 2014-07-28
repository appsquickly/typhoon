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
        if (![self isReadonlyProperty:property]) {
            NSString *selectorString = [self customSetterForProperty:property];
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

+ (SEL)getterForPropertyWithName:(NSString *)propertyName inClass:(Class)clazz
{
    SEL getterSelector = nil;
    objc_property_t property = class_getProperty(clazz, [propertyName cStringUsingEncoding:NSASCIIStringEncoding]);
    if (property) {
        NSString *getterString = [self customGetterForProperty:property];
        if (!getterString) {
            getterString = [self defaultGetterForPropertyWithName:propertyName];
        }
        getterSelector = NSSelectorFromString(getterString);
    }
    return getterSelector;
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

+ (NSSet *)methodsForClass:(Class)clazz upToParentClass:(Class)parent
{
    NSMutableSet *methodSelectors = [[NSMutableSet alloc] init];

    while (clazz != parent) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(clazz, &methodCount);
        for (unsigned int i = 0; i < methodCount; i++) {
            Method method = methodList[i];
            [methodSelectors addObject:NSStringFromSelector(method_getName(method))];
        }
        free(methodList);
        clazz = class_getSuperclass(clazz);
    }

    return methodSelectors;
}

#pragma mark - Property Attributes Utils

+ (BOOL)isReadonlyProperty:(objc_property_t)property
{
    char *readonlyFlag = property_copyAttributeValue(property, "R");
    BOOL isReadonly = readonlyFlag != NULL;
    free(readonlyFlag);
    return isReadonly;
}

+ (NSString *)customSetterForProperty:(objc_property_t)property
{
    NSString *customSetter = nil;

    char *setterName = property_copyAttributeValue(property, "S");

    if (setterName != NULL) {
        customSetter = [NSString stringWithCString:setterName encoding:NSASCIIStringEncoding];;
        free(setterName);
    }

    return customSetter;
}

+ (NSString *)customGetterForProperty:(objc_property_t)property
{
    NSString *customGetter = nil;

    char *getterName = property_copyAttributeValue(property, "G");

    if (getterName != NULL) {
        customGetter = [NSString stringWithCString:getterName encoding:NSASCIIStringEncoding];;
        free(getterName);
    }

    return customGetter;
}

+ (NSString *)defaultSetterForPropertyWithName:(NSString *)propertyName
{
    NSString *firstLetterUppercase = [[propertyName substringToIndex:1] uppercaseString];
    NSString *propertyPart = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetterUppercase];
    return [NSString stringWithFormat:@"set%@:", propertyPart];
}

+ (NSString *)defaultGetterForPropertyWithName:(NSString *)propertyName
{
    return propertyName;
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
