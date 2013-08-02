////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <objc/message.h>
#import <libxml/SAX.h>
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonInitializer.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonPropertyInjectedByValue.h"
#import "TyphoonPropertyInjectionDelegate.h"
#import "TyphoonParameterInjectedByValue.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonCollectionValue.h"
#import "TyphoonByReferenceCollectionValue.h"
#import "TyphoonTypeConvertedCollectionValue.h"
#import "TyphoonParameterInjectedByRawValue.h"
#import "TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"

@implementation TyphoonComponentFactory (InstanceBuilder)

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)buildInstanceWithDefinition:(TyphoonDefinition*)definition
{
    __autoreleasing id <TyphoonIntrospectiveNSObject> instance;

    if (definition.factoryReference)
    {
        instance = [self componentForKey:definition.factoryReference]; // clears currently resolving.
    }
    else if (definition.initializer && definition.initializer.isClassMethod)
    {
        instance = [self invokeInitializerOn:definition.type withDefinition:definition];
    }
    else
    {
        instance = [definition.type alloc];
    }

    if (definition.initializer && definition.initializer.isClassMethod == NO)
    {
        instance = [self invokeInitializerOn:instance withDefinition:definition];
    }
    else if (definition.initializer == nil)
    {
        instance = objc_msgSend(instance, @selector(init));
    }

    [self resolvePropertyDependenciesOn:instance definition:definition];
    
    return instance;
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection
- (void)resolvePropertyDependenciesOn:(__autoreleasing id)instance definition:(TyphoonDefinition *)definition
{
    [self markCurrentlyResolvingDefinition:definition withInstance:instance];
    
    [self injectPropertyDependenciesOn:instance withDefinition:definition];
    [self injectCircularDependenciesOn:instance];
    
    [self markDoneResolvingDefinition:definition];
}

- (void)markCurrentlyResolvingDefinition:(TyphoonDefinition *)definition withInstance:(__autoreleasing id)instance
{
    NSString *key = definition.key;
    [_currentlyResolvingReferences setValue:instance forKey:key];
    LogTrace(@"Building instance with definition: '%@' as part of definitions pending resolution: '%@'.", definition, _currentlyResolvingReferences);
}

- (void)injectPropertyDependenciesOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    [self doBeforePropertyInjectionOn:instance withDefinition:definition];

    for (id <TyphoonInjectedProperty> property in [definition injectedProperties])
    {
        TyphoonTypeDescriptor* typeDescriptor = [instance typeForPropertyWithName:property.name];
        if (typeDescriptor == nil)
        {
            [NSException raise:NSInvalidArgumentException
                    format:@"Tried to inject property '%@' on object of type '%@', but the instance has no setter for this property.",
                           property.name, [instance class]];
        }
        [self doPropertyInjection:instance property:property typeDescriptor:typeDescriptor];
    }

    [self doAfterPropertyInjectionOn:instance withDefinition:definition];
}

- (void)doBeforePropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    if ([instance conformsToProtocol:@protocol(TyphoonPropertyInjectionDelegate)])
    {
        [(id <TyphoonPropertyInjectionDelegate>) instance beforePropertiesSet];
    }
    if ([instance respondsToSelector:definition.beforePropertyInjection])
    {
        objc_msgSend(instance, definition.beforePropertyInjection);
    }
}

- (void)doPropertyInjection:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonInjectedProperty>)property
             typeDescriptor:(TyphoonTypeDescriptor*)typeDescriptor
{
    NSInvocation* invocation = [self propertySetterInvocationFor:instance property:property];

    if (property.injectionType == TyphoonPropertyInjectionByTypeType)
    {
        TyphoonDefinition* definition = [self definitionForType:[typeDescriptor classOrProtocol]];
        [self evaluateCircularDependency:definition.key propertyName:property.name instance:instance];
        if ([[instance circularDependentProperties] objectForKey:property.name] == nil)
        {
            id reference = [self componentForKey:definition.key];
            [invocation setArgument:&reference atIndex:2];
        }
    }
    else if (property.injectionType == TyphoonPropertyInjectionByReferenceType)
    {
        TyphoonPropertyInjectedByReference* byReference = (TyphoonPropertyInjectedByReference*) property;
        [self markByReferencePropertyAsCircularDependenceIfCurrentlyResolving:property onInstance:instance];
        if ([self propertyIsNotCircular:property instance:instance])
        {
            [self configureInvocation:invocation toInjectByReferenceProperty:byReference];
        }
    }
    else if (property.injectionType == TyphoonPropertyInjectionByValueType)
    {
        TyphoonPropertyInjectedByValue* valueProperty = (TyphoonPropertyInjectedByValue*) property;
        [self setArgumentFor:invocation index:2 textValue:valueProperty.textValue requiredType:typeDescriptor];
    }
    else if (property.injectionType == TyphoonPropertyInjectionAsCollection)
    {
        id collection = [self buildCollectionFor:(TyphoonPropertyInjectedAsCollection*) property instance:instance];
        [invocation setArgument:&collection atIndex:2];
    }
    [invocation invoke];
}

- (NSInvocation*)propertySetterInvocationFor:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonInjectedProperty>)property
{
    SEL pSelector = [instance setterForPropertyWithName:property.name];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[(NSObject*) instance methodSignatureForSelector:pSelector]];
    [invocation setTarget:instance];
    [invocation setSelector:pSelector];
    return invocation;
}

- (void)markByReferencePropertyAsCircularDependenceIfCurrentlyResolving:(TyphoonPropertyInjectedByReference *)property onInstance:(id <TyphoonIntrospectiveNSObject>)instance;
{
    [self evaluateCircularDependency:property.reference propertyName:property.name instance:instance];
}

- (void)evaluateCircularDependency:(NSString*)componentKey propertyName:(NSString*)propertyName
                          instance:(id <TyphoonIntrospectiveNSObject>)instance;
{
    if ([_currentlyResolvingReferences objectForKey:componentKey] != nil)
    {
        NSDictionary* circularDependencies = [instance circularDependentProperties];
        [circularDependencies setValue:componentKey forKey:propertyName];
        LogTrace(@"$$$$$$$$$$$$ Circular dependency detected: %@", [instance circularDependentProperties]);
    }
}

- (BOOL)propertyIsNotCircular:(id <TyphoonInjectedProperty>)property instance:(id <TyphoonIntrospectiveNSObject>)instance;
{
    return [[instance circularDependentProperties] objectForKey:property.name] == nil;
}

- (void)configureInvocation:(NSInvocation *)invocation toInjectByReferenceProperty:(TyphoonPropertyInjectedByReference *)byReference;
{
    id reference = [self componentForKey:byReference.reference];
    [invocation setArgument:&reference atIndex:2];
}

- (void)injectCircularDependenciesOn:(__autoreleasing id <TyphoonIntrospectiveNSObject>)instance
{
    NSMutableDictionary* circularDependentProperties = [instance circularDependentProperties];
    for (NSString* propertyName in [circularDependentProperties allKeys])
    {
        id propertyValue = objc_msgSend(instance, NSSelectorFromString(propertyName));
        if (!propertyValue)
        {
            SEL pSelector = [instance setterForPropertyWithName:propertyName];
            NSInvocation
            * invocation = [NSInvocation invocationWithMethodSignature:[(NSObject*) instance methodSignatureForSelector:pSelector]];
            [invocation setTarget:instance];
            [invocation setSelector:pSelector];
            NSString* componentKey = [circularDependentProperties objectForKey:propertyName];
            id reference = [_currentlyResolvingReferences objectForKey:componentKey];
            [invocation setArgument:&reference atIndex:2];
            [invocation invoke];
        }
    }
}

- (void)doAfterPropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    if ([instance conformsToProtocol:@protocol(TyphoonPropertyInjectionDelegate)])
    {
        [(id <TyphoonPropertyInjectionDelegate>) instance afterPropertiesSet];
    }
    if ([instance respondsToSelector:definition.afterPropertyInjection])
    {
        objc_msgSend(instance, definition.afterPropertyInjection);
    }
}

- (void)markDoneResolvingDefinition:(TyphoonDefinition *)definition;
{
    [_currentlyResolvingReferences removeObjectForKey:definition.key];
}

#pragma mark - End Property Injection

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (id)invokeInitializerOn:(id)instanceOrClass withDefinition:(TyphoonDefinition*)definition
{
    NSInvocation* invocation = [definition.initializer asInvocationFor:instanceOrClass];

    for (id <TyphoonInjectedParameter> parameter in [definition.initializer injectedParameters])
    {
        if (parameter.type == TyphoonParameterInjectedByReferenceType)
        {
            TyphoonParameterInjectedByReference* byReference = (TyphoonParameterInjectedByReference*) parameter;
            id reference = [self componentForKey:byReference.reference];
            [invocation setArgument:&reference atIndex:parameter.index + 2];
        }
        else if (parameter.type == TyphoonParameterInjectedByValueType)
        {
            TyphoonParameterInjectedByValue* byValue = (TyphoonParameterInjectedByValue*) parameter;
            [self setArgumentFor:invocation index:byValue.index + 2 textValue:byValue.textValue
                    requiredType:[byValue resolveTypeWith:instanceOrClass]];
        }
        else if (parameter.type == TyphoonParameterInjectedByRawValueType)
        {
            TyphoonParameterInjectedByRawValue* byValue = (TyphoonParameterInjectedByRawValue*) parameter;
            id value = byValue.value;
            [invocation setArgument:&value atIndex:parameter.index + 2];
        }
    }
    [invocation invoke];
    __autoreleasing id <NSObject> returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

/* ====================================================================================================================================== */
- (void)setArgumentFor:(NSInvocation*)invocation index:(NSUInteger)index1 textValue:(NSString*)textValue
        requiredType:(TyphoonTypeDescriptor*)requiredType
{
    if (requiredType.isPrimitive)
    {
        TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        [converter setPrimitiveArgumentFor:invocation index:index1 textValue:textValue requiredType:requiredType];
    }
    else
    {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:requiredType];
        id converted = [converter convert:textValue];
        [invocation setArgument:&converted atIndex:index1];
    }
}

- (id)buildCollectionFor:(TyphoonPropertyInjectedAsCollection*)propertyInjectedAsCollection
        instance:(id <TyphoonIntrospectiveNSObject>)instance
{
    id collection = [self collectionFor:propertyInjectedAsCollection givenInstance:instance];

    for (id <TyphoonCollectionValue> value in [propertyInjectedAsCollection values])
    {
        if (value.type == TyphoonCollectionValueTypeByReference)
        {
            TyphoonByReferenceCollectionValue* byReferenceValue = (TyphoonByReferenceCollectionValue*) value;
            id reference = [self componentForKey:byReferenceValue.componentName];
            [collection addObject:reference];
        }
        else if (value.type == TyphoonCollectionValueTypeConvertedText)
        {
            TyphoonTypeConvertedCollectionValue* typeConvertedValue = (TyphoonTypeConvertedCollectionValue*) value;
            TyphoonTypeDescriptor* descriptor = [TyphoonTypeDescriptor descriptorWithClassOrProtocol:typeConvertedValue.requiredType];
            id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:descriptor];
            id converted = [converter convert:typeConvertedValue.textValue];
            [collection addObject:converted];
        }
    }
    BOOL isMutable = propertyInjectedAsCollection.injectionType == TyphoonCollectionTypeNSMutableArray ||
            propertyInjectedAsCollection.injectionType == TyphoonCollectionTypeNSMutableSet;
    return propertyInjectedAsCollection.injectionType == isMutable ? [collection copy] : collection;
}

- (id)collectionFor:(TyphoonPropertyInjectedAsCollection*)propertyInjectedAsCollection
        givenInstance:(id <TyphoonIntrospectiveNSObject>)instance
{
    TyphoonCollectionType type = [propertyInjectedAsCollection resolveCollectionTypeWith:instance];
    id collection;
    if (type == TyphoonCollectionTypeNSArray || type == TyphoonCollectionTypeNSMutableArray)
    {
        collection = [[NSMutableArray alloc] init];
    }
    else if (type == TyphoonCollectionTypeNSCountedSet)
    {
        collection = [[NSCountedSet alloc] init];
    }
    else if (type == TyphoonCollectionTypeNSSet || type == TyphoonCollectionTypeNSMutableSet)
    {
        collection = [[NSMutableSet alloc] init];
    }

    return collection;
}


- (TyphoonDefinition*)definitionForType:(id)classOrProtocol
{
    NSArray* candidates = [self allDefinitionsForType:classOrProtocol];
    if ([candidates count] == 0)
    {
        if (class_isMetaClass(object_getClass(classOrProtocol)) &&
                [classOrProtocol respondsToSelector:@selector(typhoonAutoInjectedProperties)])
        {
            LogTrace(@"Class %@ wants auto-wiring. . . registering.", NSStringFromClass(classOrProtocol));
            [self register:[TyphoonDefinition withClass:classOrProtocol]];
            return [self definitionForType:classOrProtocol];
        }
        [NSException raise:NSInvalidArgumentException format:@"No components defined which satisify type: '%@'",
                                                             TyphoonTypeStringFor(classOrProtocol)];
    }
    if ([candidates count] > 1)
    {
        [NSException raise:NSInvalidArgumentException format:@"More than one component is defined satisfying type: '%@'", classOrProtocol];
    }
    return [candidates objectAtIndex:0];
}


- (NSArray*)allDefinitionsForType:(id)classOrProtocol
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));

    for (TyphoonDefinition* definition in _registry)
    {
        if (isClass)
        {
            if (definition.type == classOrProtocol || [definition.type isSubclassOfClass:classOrProtocol])
            {
                [results addObject:definition];
            }
        }
        else
        {
            if ([definition.type conformsToProtocol:classOrProtocol])
            {
                [results addObject:definition];
            }
        }
    }
    return [results copy];
}


@end