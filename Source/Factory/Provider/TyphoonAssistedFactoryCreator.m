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

#import "TyphoonAssistedFactoryCreator.h"
#import "TyphoonAssistedFactoryCreator+Private.h"

#import "TyphoonAssistedFactoryBase.h"
#import "TyphoonAssistedFactoryCreatorImplicit.h"
#import "TyphoonAssistedFactoryCreatorOneFactory.h"
#import "TyphoonAssistedFactoryCreatorManyFactories.h"
#import "TyphoonAssistedFactoryMethodCreator.h"
#import "TyphoonPropertyInjectionInternalDelegate.h"


SEL TyphoonAssistedFactoryCreatorGuessFactoryMethodForProtocol(Protocol *protocol) {
    // Lets create two sets: the property getters and all the methods (including
    // those getters). The difference must be only one, and must be our method.
    NSMutableSet *propertyNames = [NSMutableSet set];
    NSMutableSet *methodNames = [NSMutableSet set];

    TyphoonAssistedFactoryCreatorForEachMethodInProtocol(protocol, ^(struct objc_method_description methodDescription) {
        [methodNames addObject:NSStringFromSelector(methodDescription.name)];
    });

    TyphoonAssistedFactoryCreatorForEachPropertyInProtocol(protocol, ^(objc_property_t property) {
        [propertyNames addObject:[NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding]];
    });

    [methodNames minusSet:propertyNames];
    NSString *factoryMethod = [methodNames anyObject];

    return NSSelectorFromString(factoryMethod);
}

void TyphoonAssistedFactoryCreatorForEachMethodInProtocol(Protocol *protocol, TyphoonAssistedFactoryCreatorMethodEnumeration enumerationBlock) {
    unsigned int methodCount = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &methodCount);
    for (unsigned int idx = 0; idx < methodCount; idx++) {
        struct objc_method_description methodDescription = methodDescriptions[idx];
        enumerationBlock(methodDescription);
    }
    free(methodDescriptions);
}

void TyphoonAssistedFactoryCreatorForEachPropertyInProtocol(Protocol *protocol, TyphoonAssistedFactoryCreatorPropertyEnumeration enumerationBlock) {
    unsigned int propertiesCount = 0;
    objc_property_t *properties = protocol_copyPropertyList(protocol, &propertiesCount);
    for (unsigned int idx = 0; idx < propertiesCount; idx++) {
        objc_property_t property = properties[idx];
        enumerationBlock(property);
    }
    free(properties);
}

void TyphoonAssistedFactoryCreatorForEachMethodInClass(Class klass, TyphoonAssistedFactoryCreatorMethodEnumeration enumerationBlock) {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(klass, &methodCount);
    for (unsigned int idx = 0; idx < methodCount; idx++) {
        Method method = methods[idx];
        struct objc_method_description *methodDescription = method_getDescription(method);
        enumerationBlock(*methodDescription);
    }
    free(methods);
}

@implementation TyphoonAssistedFactoryCreator
{
    TyphoonAssistedFactoryDefinitionProvider _definitionProvider;
}

static dispatch_queue_t sQueue;

static NSString *GetFactoryClassName(Protocol *protocol) {
    return [NSString stringWithFormat:@"%s__TyphoonAssistedFactoryImpl", protocol_getName(protocol)];
}

static void AssertValidProtocolForFactory(Protocol *protocol, TyphoonAssistedFactoryDefinition *factoryDefinition) {
    unsigned int methodCount = 0;
    unsigned int propertiesCount = 0;

    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &methodCount);
    objc_property_t *properties = protocol_copyPropertyList(protocol, &propertiesCount);
    free(methodDescriptions);
    free(properties);

    // The readonly properties are returned also as their getter methods, so we
    // need to remove those to check that there are only n factory methods left.
    NSCAssert(methodCount - propertiesCount ==
        [factoryDefinition countOfFactoryMethods], @"protocol factory method count (%u) differs from factory defintion method count (%lu)",
    methodCount - propertiesCount, (unsigned long) [factoryDefinition countOfFactoryMethods]);
}

static void AddPropertyGetter(Class factoryClass, objc_property_t property) {
    // This dummy will give us the type encodings of the properties.
    // Only object properties are supported.
    Method getter = class_getInstanceMethod([TyphoonAssistedFactoryBase class], @selector(_dummyGetter));

    const char *cName = property_getName(property);
    NSString *name = [NSString stringWithCString:cName encoding:NSASCIIStringEncoding];
    SEL getterSEL = sel_registerName(cName);

    IMP getterIMP = imp_implementationWithBlock(^id(TyphoonAssistedFactoryBase *_self) {
        return [_self dependencyValueForProperty:name];
    });
    class_addMethod(factoryClass, getterSEL, getterIMP, method_getTypeEncoding(getter));
}

static void AddPropertySetter(Class factoryClass, objc_property_t property) {
    // This dummy will give us the type encodings of the properties.
    // Only object properties are supported.
    Method setter = class_getInstanceMethod([TyphoonAssistedFactoryBase class], @selector(_setDummySetter:));

    const char *cName = property_getName(property);
    NSString *name = [NSString stringWithCString:cName encoding:NSASCIIStringEncoding];
    NSString
        *setterName = [NSString stringWithFormat:@"set%@%@:", [[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]];
    SEL setterSEL = sel_registerName([setterName cStringUsingEncoding:NSASCIIStringEncoding]);

    IMP setterIMP = imp_implementationWithBlock(^(TyphoonAssistedFactoryBase *_self, id value) {
        [_self setDependencyValue:value forProperty:name];
    });
    class_addMethod(factoryClass, setterSEL, setterIMP, method_getTypeEncoding(setter));
}

static void AddProperty(Class factoryClass, objc_property_t property) {
    unsigned int propertyAttributesCount = 0;
    const char *cName = property_getName(property);
    objc_property_attribute_t *propertyAttributes = property_copyAttributeList(property, &propertyAttributesCount);
    class_addProperty(factoryClass, cName, propertyAttributes, propertyAttributesCount);
}

static void AddPropertiesToFactory(Class factoryClass, Protocol *protocol) {
    unsigned int propertiesCount = 0;
    objc_property_t *properties = protocol_copyPropertyList(protocol, &propertiesCount);
    for (unsigned int idx = 0; idx < propertiesCount; idx++) {
        objc_property_t property = properties[idx];
        AddPropertyGetter(factoryClass, property);
        AddPropertySetter(factoryClass, property);
        AddProperty(factoryClass, property);
    }
    free(properties);
}

static void AddFactoryMethodsToFactory(Class factoryClass, Protocol *protocol, TyphoonAssistedFactoryDefinition *definition) {
    [definition enumerateFactoryMethods:^(id <TyphoonAssistedFactoryMethod> factoryMethod) {
        [[TyphoonAssistedFactoryMethodCreator creatorFor:factoryMethod] createFromProtocol:protocol inClass:factoryClass];
    }];
}

static Class GenerateFactoryClassWithDefinition(Protocol *protocol, TyphoonAssistedFactoryDefinition *factoryDefinition) {
    NSString *className = GetFactoryClassName(protocol);
    const char *cClassName = [className cStringUsingEncoding:NSASCIIStringEncoding];

    AssertValidProtocolForFactory(protocol, factoryDefinition);

    Class factoryClass = objc_allocateClassPair([TyphoonAssistedFactoryBase class], cClassName, 0);
    // Add the factory method first, that way, the setters from the properties
    // will not exist yet.
    AddFactoryMethodsToFactory(factoryClass, protocol, factoryDefinition);
    AddPropertiesToFactory(factoryClass, protocol);
    class_addProtocol(factoryClass, protocol);
    objc_registerClassPair(factoryClass);

    return factoryClass;
}

static Class GetExistingFactoryClass(Protocol *protocol) {
    NSString *className = GetFactoryClassName(protocol);
    const char *cClassName = [className cStringUsingEncoding:NSASCIIStringEncoding];
    return objc_getClass(cClassName);
}

static Class EnsureFactoryClass(Protocol *protocol, TyphoonAssistedFactoryDefinitionProvider definitionProvider) {
    Class factoryClass = GetExistingFactoryClass(protocol);
    if (!factoryClass) {
        // At this point we need the factory definition, so we can invoke the
        // block to get it.
        factoryClass = GenerateFactoryClassWithDefinition(protocol, definitionProvider());
    }

    return factoryClass;
}

+ (void)initialize
{
    if (self == [TyphoonAssistedFactoryCreator class]) {
        sQueue = dispatch_queue_create("org.typhoonframework.TyphoonAssistedFactoryCreator", DISPATCH_QUEUE_SERIAL);
    }
}

+ (instancetype)creatorWithProtocol:(Protocol *)protocol returns:(Class)returnType
{
    return [[TyphoonAssistedFactoryCreatorImplicit alloc] initWithProtocol:protocol returns:returnType];
}

+ (instancetype)creatorWithProtocol:(Protocol *)protocol factoryBlock:(id)factoryBlock
{
    return [[TyphoonAssistedFactoryCreatorOneFactory alloc] initWithProtocol:protocol factoryBlock:factoryBlock];
}

+ (instancetype)creatorWithProtocol:(Protocol *)protocol factories:(TyphoonAssistedFactoryDefinitionBlock)definitionblock
{
    return [[TyphoonAssistedFactoryCreatorManyFactories alloc] initWithProtocol:protocol factories:definitionblock];
}

- (instancetype)initWithProtocol:(Protocol *)protocol factoryDefinitionProvider:(TyphoonAssistedFactoryDefinitionProvider)definitionProvider
{
    self = [super init];
    if (self) {
        _protocol = protocol;
        _definitionProvider = definitionProvider;
    }

    return self;
}

- (Class)factoryClass
{
    __block Class factoryClass = nil;
    dispatch_sync(sQueue, ^{
        factoryClass = EnsureFactoryClass(_protocol, _definitionProvider);
    });

    return factoryClass;
}

@end
