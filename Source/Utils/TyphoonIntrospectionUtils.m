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
