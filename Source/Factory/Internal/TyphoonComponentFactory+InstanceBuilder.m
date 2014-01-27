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


#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonComponentFactory_InstanceBuilder)

#import <objc/message.h>
#import <CoreData/CoreData.h>
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonInitializer.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonPropertyInjectedByFactoryReference.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonPropertyInjectedWithStringRepresentation.h"
#import "TyphoonPropertyInjectionDelegate.h"
#import "TyphoonParameterInjectedWithStringRepresentation.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonCollectionValue.h"
#import "TyphoonByReferenceCollectionValue.h"
#import "TyphoonTypeConvertedCollectionValue.h"
#import "TyphoonParameterInjectedWithObjectInstance.h"
#import "TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"
#import "TyphoonPropertyInjectedAsObjectInstance.h"
#import "TyphoonComponentFactoryAware.h"
#import "TyphoonParameterInjectedAsCollection.h"
#import "TyphoonComponentPostProcessor.h"
#import "TyphoonResolutionStack.h"
#import "TyphoonStackItem.h"
#import "NSObject+PropertyInjection.h"

#define AssertTypeDescriptionForPropertyOnInstance(type, property, instance) if (!type)[NSException raise:@"NSUnknownKeyException" \
format:@"Tried to inject property '%@' on object of type '%@', but the instance has no setter for this property.",property.name, [instance class]]

@implementation TyphoonComponentFactory (InstanceBuilder)

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)buildInstanceWithDefinition:(TyphoonDefinition*)definition
{
    __autoreleasing id <TyphoonIntrospectiveNSObject> instance = [self allocateInstance:instance withDefinition:definition];
    [_currentlyResolvingReferences push:[TyphoonStackItem itemWithDefinition:definition instance:instance]];
    instance = [self injectInstance:instance withDefinition:definition];
    instance = [self postProcessInstance:instance];
    [_currentlyResolvingReferences pop];
    return instance;
}

- (id)allocateInstance:(id)instance withDefinition:(TyphoonDefinition*)definition
{
    if (definition.factoryReference)
    {
        // misleading - this is not the instance. this is an instance of a separate class that will create the instance of the class we care
        // about.
        instance = [self componentForKey:definition.factoryReference]; // clears currently resolving.
    }
    else if (definition.initializer && definition.initializer.isClassMethod)
    {
        // this is an instance of the class, needing no more init.
        instance = [self invokeInitializer:definition.initializer on:definition.type];
    }
    else
    {
        // this is an instance, needing later init.
        instance = [definition.type alloc];
    }

    [self handleSpecialCaseForNSManagedObjectModel:instance];

    return instance;
}


- (id)injectInstance:(id)instance withDefinition:(TyphoonDefinition*)definition
{
    instance = [self initializerInjectionOn:instance withDefinition:definition];
    [self injectPropertyDependenciesOn:instance withDefinition:definition];
    return instance;
}

- (id)postProcessInstance:(id)instance
{
    if (![instance conformsToProtocol:@protocol(TyphoonComponentPostProcessor)])
    {
        for (id <TyphoonComponentPostProcessor> postProcessor in _componentPostProcessors)
        {
            instance = [postProcessor postProcessComponent:instance];
        }
    }
    return instance;
}

- (id)initializerInjectionOn:(id)instance withDefinition:(TyphoonDefinition*)definition
{
    if (definition.initializer)
    {
        if (definition.initializer.isClassMethod == NO)
        {
            instance = [self invokeInitializer:definition.initializer on:instance];
        }
        else
        {
            // initializer was already invoked in allocateInstance:withDefinition:
        }
    }
    else if (definition.initializer == nil)
    {
        instance = [self invokeDefaultInitializerOn:instance];
    }

    return instance;
}

- (id)invokeDefaultInitializerOn:(id)instance
{
    id initializedInstance = objc_msgSend(instance, @selector(init));
    return initializedInstance;
}

- (void)injectAssemblyOnInstanceIfTyphoonAware:(id)instance;
{
    if ([instance conformsToProtocol:@protocol(TyphoonComponentFactoryAware)])
    {
        [self injectAssemblyOnInstance:instance];
    }
}

- (void)injectAssemblyOnInstance:(id <TyphoonComponentFactoryAware>)instance;
{
    [instance setFactory:self];
}

- (id)buildSharedInstanceForDefinition:(TyphoonDefinition*)definition
{
    if ([self alreadyResolvingKey:definition.key])
    {
        return [_currentlyResolvingReferences peekWithKey:definition.key].instance;
    }
    return [self buildInstanceWithDefinition:definition];
}


- (BOOL)alreadyResolvingKey:(NSString*)key
{
    return [_currentlyResolvingReferences peekWithKey:key] != nil;
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)injectPropertyDependenciesOn:(__autoreleasing id)instance withDefinition:(TyphoonDefinition*)definition
{
    [self doBeforePropertyInjectionOn:instance withDefinition:definition];

    for (TyphoonAbstractInjectedProperty* property in [definition injectedProperties])
    {
        [self doPropertyInjection:instance property:property];
    }

    [self injectAssemblyOnInstanceIfTyphoonAware:instance];
    [self injectCircularDependenciesOn:instance];

    [self doAfterPropertyInjectionOn:instance withDefinition:definition];
}

- (void)doBeforePropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    if ([instance respondsToSelector:@selector(beforePropertiesSet)])
    {
        [(id <TyphoonPropertyInjectionDelegate>)instance beforePropertiesSet];
    }

    if ([instance respondsToSelector:definition.beforePropertyInjection])
    {
        objc_msgSend(instance, definition.beforePropertyInjection);
    }
}

- (void)doPropertyInjection:(id <TyphoonIntrospectiveNSObject>)instance property:(TyphoonAbstractInjectedProperty*)property
{
    TyphoonTypeDescriptor* propertyType = [instance typeForPropertyWithName:property.name];
    AssertTypeDescriptionForPropertyOnInstance(propertyType, property, instance);
    
    id valueToInject = [self valueToInjectProperty:property withType:propertyType onInstance:instance];
    
    if (valueToInject)
    {
        [(NSObject*)instance injectValue:valueToInject forPropertyName:property.name withType:propertyType];
    }
}

- (id)valueToInjectProperty:(TyphoonAbstractInjectedProperty*)property withType:(TyphoonTypeDescriptor*)type onInstance:(id <TyphoonIntrospectiveNSObject>)instance
{
    id valueToInject = nil;

    if (property.injectionType == TyphoonPropertyInjectionTypeByType)
    {
        TyphoonDefinition* definition = [self definitionForType:[type classOrProtocol]];

        [self evaluateCircularDependency:definition.key propertyName:property.name instance:instance];
        if (![self propertyIsCircular:property onInstance:instance])
        {
            valueToInject = [self componentForKey:definition.key];
        }
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeByReference)
    {
        TyphoonPropertyInjectedByReference* byReference = (TyphoonPropertyInjectedByReference*)property;
        [self evaluateCircularDependency:byReference.reference propertyName:property.name instance:instance];

        if (![self propertyIsCircular:property onInstance:instance])
        {
            valueToInject = [self componentForKey:byReference.reference];
        }
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeByFactoryReference)
    {
        TyphoonPropertyInjectedByFactoryReference* byReference = (TyphoonPropertyInjectedByFactoryReference*)property;
        [self evaluateCircularDependency:byReference.reference propertyName:property.name instance:instance];

        if (![self propertyIsCircular:property onInstance:instance])
        {
            id factoryReference = [self componentForKey:byReference.reference];
            valueToInject = [factoryReference valueForKeyPath:byReference.keyPath];
        }
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeAsCollection)
    {
        valueToInject = [self buildCollectionFor:(TyphoonPropertyInjectedAsCollection*)property instance:instance];
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeAsObjectInstance)
    {
        valueToInject = ((TyphoonPropertyInjectedAsObjectInstance*)property).objectInstance;
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeAsStringRepresentation)
    {
        TyphoonPropertyInjectedWithStringRepresentation* valueProperty = (TyphoonPropertyInjectedWithStringRepresentation*)property;
        valueToInject = [self valueFromTextValue:valueProperty.textValue requiredType:type];
    }

    return valueToInject;
}

- (void)evaluateCircularDependency:(NSString*)componentKey propertyName:(NSString*)propertyName
        instance:(id <TyphoonIntrospectiveNSObject>)instance;
{
    if ([self alreadyResolvingKey:componentKey])
    {
        NSDictionary* circularDependencies = [instance circularDependentProperties];
        [circularDependencies setValue:componentKey forKey:propertyName];
        LogTrace(@"Circular dependency detected: %@", [instance circularDependentProperties]);
    }
}

- (BOOL)propertyIsCircular:(TyphoonAbstractInjectedProperty*)property onInstance:(id <TyphoonIntrospectiveNSObject>)instance;
{
    return [[instance circularDependentProperties] objectForKey:property.name] != nil;
}

- (void)injectCircularDependenciesOn:(__autoreleasing id <TyphoonIntrospectiveNSObject>)instance
{
    NSMutableDictionary* circularDependentProperties = [instance circularDependentProperties];
    for (NSString* propertyName in [circularDependentProperties allKeys])
    {
        id propertyValue = [(NSObject*)instance valueForKey:propertyName];
        if (!propertyValue)
        {
            NSString* componentKey = [circularDependentProperties objectForKey:propertyName];
            id reference = [_currentlyResolvingReferences peekWithKey:componentKey].instance;
            [(NSObject*)instance setValue:reference forKey:propertyName];
        }
    }
}

- (void)doAfterPropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    if ([instance respondsToSelector:@selector(afterPropertiesSet)])
    {
        [(id <TyphoonPropertyInjectionDelegate>)instance afterPropertiesSet];
    }

    if ([instance respondsToSelector:definition.afterPropertyInjection])
    {
        objc_msgSend(instance, definition.afterPropertyInjection);
    }
}

#pragma mark - End Property Injection

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (id)invokeInitializer:(TyphoonInitializer*)initializer on:(id)instanceOrClass
{
    NSInvocation* invocation = [initializer asInvocationFor:instanceOrClass];

    NSArray* injectedParameters = [initializer injectedParameters];
    for (id <TyphoonInjectedParameter> parameter in injectedParameters)
    {
        if (parameter.type == TyphoonParameterInjectionTypeReference)
        {
            TyphoonParameterInjectedByReference* byReference = (TyphoonParameterInjectedByReference*)parameter;
            id reference = [self componentForKey:byReference.reference];
            [invocation setArgument:&reference atIndex:parameter.index + 2];
        }
        else if (parameter.type == TyphoonParameterInjectionTypeStringRepresentation)
        {
            TyphoonParameterInjectedWithStringRepresentation* byValue = (TyphoonParameterInjectedWithStringRepresentation*)parameter;
            [self setArgumentFor:invocation index:byValue.index + 2 textValue:byValue.textValue
                    requiredType:[byValue resolveTypeWith:instanceOrClass]];
        }
        else if (parameter.type == TyphoonParameterInjectionTypeObjectInstance)
        {
            TyphoonParameterInjectedWithObjectInstance* byInstance = (TyphoonParameterInjectedWithObjectInstance*)parameter;
            id value = byInstance.value;
            BOOL isValuesIsWrapper = [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSValue class]];

            if (isValuesIsWrapper && [byInstance isPrimitiveParameterFor:instanceOrClass]) {
                [self setPrimitiveArgumentForInvocation:invocation index:parameter.index + 2 fromValue:value];
            } else {
                [invocation setArgument:&value atIndex:parameter.index + 2];
            }
        }
        else if (parameter.type == TyphoonParameterInjectionTypeAsCollection)
        {
            TyphoonParameterInjectedAsCollection* asCollection = (TyphoonParameterInjectedAsCollection*)parameter;
            id collection = [self buildCollectionWithValues:asCollection.values requiredType:asCollection.collectionType];
            [invocation setArgument:&collection atIndex:parameter.index + 2];
        }
    }
    [invocation invoke];
    __autoreleasing id <NSObject> returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

/* ====================================================================================================================================== */


- (id)valueFromTextValue:(NSString*)textValue requiredType:(TyphoonTypeDescriptor*)requiredType
{
    id value = nil;

    if (requiredType.isPrimitive)
    {
        TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        value = [converter valueFromText:textValue withType:requiredType];
    }
    else
    {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:requiredType];
        value = [converter convert:textValue];
    }

    return value;
}

- (void)setPrimitiveArgumentForInvocation:(NSInvocation *)invocation index:(NSUInteger)index fromValue:(id)value
{
    TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
    [converter setPrimitiveArgumentFor:invocation index:index fromValue:value];
}

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
    TyphoonCollectionType type = [propertyInjectedAsCollection resolveCollectionTypeWith:instance];
    return [self buildCollectionWithValues:[propertyInjectedAsCollection values] requiredType:type];
}

- (id)buildCollectionWithValues:(NSArray*)values requiredType:(TyphoonCollectionType)type
{
    id collection = [self collectionForType:type];

    for (id <TyphoonCollectionValue> value in values)
    {
        if (value.type == TyphoonCollectionValueTypeByReference)
        {
            TyphoonByReferenceCollectionValue* byReferenceValue = (TyphoonByReferenceCollectionValue*)value;
            id reference = [self componentForKey:byReferenceValue.componentName];
            [collection addObject:reference];
        }
        else if (value.type == TyphoonCollectionValueTypeConvertedText)
        {
            TyphoonTypeConvertedCollectionValue* typeConvertedValue = (TyphoonTypeConvertedCollectionValue*)value;
            TyphoonTypeDescriptor* descriptor = [TyphoonTypeDescriptor descriptorWithClassOrProtocol:typeConvertedValue.requiredType];
            id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:descriptor];
            id converted = [converter convert:typeConvertedValue.textValue];
            [collection addObject:converted];
        }
    }

    BOOL isMutable = (type == TyphoonCollectionTypeNSMutableArray || type == TyphoonCollectionTypeNSMutableSet);
    return isMutable ? collection : [collection copy];
}

- (id)collectionForType:(TyphoonCollectionType)type
{
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
        SEL autoInjectedProperties = sel_registerName("typhoonAutoInjectedProperties");
        if (class_isMetaClass(object_getClass(classOrProtocol)) && [classOrProtocol respondsToSelector:autoInjectedProperties])
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

/**
* FIXME:
* NSManagedObjectModelReturns a different pointer from init than from alloc, Typhoon+ARC is not currently picking this up.
* Other classes that do this (and work fine with Typhoon) : Class clusters, eg NSString, NSArray, NSURL
*/
- (void)handleSpecialCaseForNSManagedObjectModel:(id)instance
{
    if ([instance isKindOfClass:[NSManagedObjectModel class]])
    {
        LogInfo("FixMe: Ensuring NSManagedObjectModel is not over-released.");
        objc_msgSend(instance, NSSelectorFromString(@"retain"));

    }
}


@end
