////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
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

BOOL TyphoonIsInvalidClassName(NSString *className);
NSString *TyphoonDefaultModuleName(void);
Class TyphoonClassFromFrameworkString(NSString *className);

+ (TyphoonTypeDescriptor *)typeForPropertyNamed:(NSString *)propertyName inClass:(Class)clazz
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

        NSUInteger len = (NSUInteger) (e - attributes);
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
    NSMutableString *signatureString = [[NSMutableString alloc]
        initWithCapacity:argc + 3]; //one symbol per encoded type
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

    while (clazz && clazz != parent) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(clazz, &count);

        for (unsigned int propertyIndex = 0; propertyIndex < count; propertyIndex++) {
            objc_property_t aProperty = properties[propertyIndex];
            NSString *propertyName = [NSString stringWithCString:property_getName(aProperty)
                encoding:NSUTF8StringEncoding];

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

    while (clazz && clazz != parent) {
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

+ (NSString *)classNameOfProperty:(objc_property_t)property
{
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property)
        encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
    if (splitPropertyAttributes.count >= 2) {

        return [splitPropertyAttributes objectAtIndex:1];
    }

    return nil;
}

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
    NSString *propertyPart = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
        withString:firstLetterUppercase];
    return [NSString stringWithFormat:@"set%@:", propertyPart];
}

+ (NSString *)defaultGetterForPropertyWithName:(NSString *)propertyName
{
    return propertyName;
}

@end


NSString *TyphoonTypeStringFor(id classOrProtocol)
{
    if (IsClass(classOrProtocol)) {
        return NSStringFromClass(classOrProtocol);
    }
    else {
        return [NSString stringWithFormat:@"id<%@>", NSStringFromProtocol(classOrProtocol)];
    }
}

NSString *TyphoonDefaultModuleName(void)
{
    static NSString *defaultModuleName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultModuleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
        defaultModuleName = [[defaultModuleName stringByReplacingOccurrencesOfString:@" " withString:@"_"]
                             stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    });
    return defaultModuleName;
}

BOOL TyphoonIsInvalidClassName(NSString *className)
{
    if (className.length == 0) {
        return YES;
    }
    if ([className isEqualToString:@"?"]) {
        return YES;
    }
    return NO;
}

Class TyphoonClassFromString(NSString *className)
{
    if (TyphoonIsInvalidClassName(className)) {
        return Nil;
    }
    
    Class clazz = NSClassFromString(className);
    if (!clazz) {
        clazz = NSClassFromString([TyphoonDefaultModuleName() stringByAppendingFormat:@".%@", className]);
    }
    if (!clazz) {
        /**
        Swift issue:
        When calling property_getAttributes() for a Swift class that belongs in a different
        module, the module name is *NOT* returned, therefore attempting to resolve the
        Swift class via name wont work:

        1. Foo.BarAssembly in Foo.framework
        2. App.app includes Foo.framework and references Foo.BarAssembly in AppAssembly

        import Foo

        class AppAssembly: TyphonAssembly {

        var barAssembly: Foo.BarAssembly?
        }
        3. property_getAttributes() called on `barAssembly` returns @T"BarAssembly" but
        should return @T"Foo.BarAssembly"
        4. NSClassforString("BarAssembly") returns nil because the App.app does not define
        this class

        Poor workaround, not the best, but no other way around it unless Apple fixes the objc reflection of
        Swift classes there is no other way:

        If we are unable to find the class in the top level project iterate all dynamic
        frameworks and attempt to resolve the class name by appending the module name

        This is somewhat brittle as we loose the namespacing modules give us (for example,
        if 2 modules define the same class then which ever appears first in the list will
        be used which might not be expected). In order for this to work, developers are required
        to:
        - have unique names of assemblies across modules
        - frameworks bundle ids much match the following format: *.{Name} where Name is
        the name of the module

        */
        
        //Those class names will never be resolved, so no reason to try
        if(!className || [className isEqual:@"?"] || [className isEqual:@""]) {
            return nil;
        }
        
        clazz = TyphoonClassFromFrameworkString(className);
        
    }
    return clazz;
}


#if TARGET_OS_IOS
Class TyphoonClassFromFrameworkString(NSString *className) {
    
    Class clazz = nil;
    // on iOS, we can safely precache frameworks
    // because they'll never change during app lifetime
    static NSArray * frameworkNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray * temporaryNames = [NSMutableArray array];
        NSArray *frameworks = [NSBundle allFrameworks];
        [frameworks enumerateObjectsUsingBlock:^(NSBundle*  _Nonnull framework, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *bundleIdentifier = [framework bundleIdentifier];
            // ignore apple frameworks and resource bundles
            if (bundleIdentifier && ![bundleIdentifier hasPrefix:@"com.apple"]) {
                [temporaryNames addObject:bundleIdentifier];
            }
        }];
        frameworkNames = [temporaryNames copy];
    });
    
    for (uint i = 0; i < frameworkNames.count && clazz == nil; ++i) {
        NSString *bundleIdentifier = frameworkNames[i];
        NSRange range = [bundleIdentifier rangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            NSString *frameworkName = [bundleIdentifier substringFromIndex:range.location + 1];
            if (frameworkName != nil) {
                clazz = NSClassFromString([frameworkName stringByAppendingFormat:@".%@", className]);
            }
        }
    }
    return clazz;
}
#else
Class TyphoonClassFromFrameworkString(NSString *className) {
    // For OSX we still need to iterate, since platform allows us to use downloaded frameworks
    // and they can change during app lifetime
    Class clazz = nil;
    NSArray *frameworks = [NSBundle allFrameworks];
    for (uint i = 0; i < frameworks.count && clazz == nil; ++i) {
        NSBundle *framework = [frameworks objectAtIndex:i];
        NSString *bundleIdentifier = [framework bundleIdentifier];
        // ignore apple frameworks
        if (![bundleIdentifier hasPrefix:@"com.apple"]) {
            NSRange range = [bundleIdentifier rangeOfString:@"." options:NSBackwardsSearch];
            if (range.location != NSNotFound) {
                NSString *frameworkName = [bundleIdentifier substringFromIndex:range.location + 1];
                if (frameworkName != nil) {
                    clazz = NSClassFromString([frameworkName stringByAppendingFormat:@".%@", className]);
                }
            }
        }
    }
    return clazz;
}
#endif

BOOL IsClass(id classOrProtocol)
{
    return class_isMetaClass(object_getClass(classOrProtocol));
}

BOOL IsProtocol(id classOrProtocol)
{
    return object_getClass(classOrProtocol) == object_getClass(@protocol(NSObject));
}

