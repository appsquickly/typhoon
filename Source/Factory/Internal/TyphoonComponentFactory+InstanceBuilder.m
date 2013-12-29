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
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"

@implementation TyphoonComponentFactory (InstanceBuilder)

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)buildInstanceWithDefinition:(TyphoonDefinition*)definition
{
    __autoreleasing id <TyphoonIntrospectiveNSObject> instance;
    instance = [self allocateInstance:instance withDefinition:definition];
    instance = [self injectInstance:instance withDefinition:definition];
    return instance;
}

- (id)allocateInstance:(id)instance withDefinition:(TyphoonDefinition*)definition
{
    if (definition.factoryReference)
    {
        // misleading - this is not the instance. this is an instance of a seperate class tnat will create the instance of the class we care about.
        // consider it an allocator
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
    [self markCurrentlyResolvingDefinition:definition withInstance:instance];

    instance = [self initializerInjectionOn:instance withDefinition:definition];
    [self propertyInjectionOn:instance withDefinition:definition];
    [self injectAssemblyOnInstanceIfTyphoonAware:instance];

    [self markDoneResolvingDefinition:definition];

    return instance;
}

- (void)markCurrentlyResolvingDefinition:(TyphoonDefinition*)definition withInstance:(__autoreleasing id)instance
{
    NSString* key = definition.key;
    [_currentlyResolvingReferences stashInstance:instance forKey:key];
    LogTrace(@"Building instance with definition: '%@' as part of definitions pending resolution: '%@'.", definition, _currentlyResolvingReferences);
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
        if ([self definitionHasParent:definition])
        {
            instance = [self initializerInjectionOn:instance withDefinition:[self parentForDefinition:definition]];
        }
        else
        {
            instance = [self invokeDefaultInitializerOn:instance];
        }
    }

    return instance;
}

- (BOOL)definitionHasParent:(TyphoonDefinition*)definition
{
    return definition.parent || definition.parentRef;
}

- (TyphoonDefinition*)parentForDefinition:(TyphoonDefinition*)definition
{
    if (definition.parent)
    {
        return definition.parent;
    }
    else if (definition.parentRef)
    {
        return [self definitionForKey:definition.parentRef];
    }
    else
    {
        return nil;
    }
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

- (void)markDoneResolvingDefinition:(TyphoonDefinition*)definition;
{
    [_currentlyResolvingReferences unstashInstanceForKey:definition.key];
}

- (id)buildSingletonWithDefinition:(TyphoonDefinition*)definition
{
    if ([self alreadyResolvingDefinition:definition])
    {
        return [_currentlyResolvingReferences peekInstanceForKey:definition.key];
    }
    return [self buildInstanceWithDefinition:definition];
}

- (BOOL)alreadyResolvingDefinition:(TyphoonDefinition*)definition
{
    return [self alreadyResolvingKey:definition.key];
}

- (BOOL)alreadyResolvingKey:(NSString*)key
{
    return [_currentlyResolvingReferences hasInstanceForKey:key];
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection
- (void)propertyInjectionOn:(__autoreleasing id)instance withDefinition:(TyphoonDefinition*)definition
{
    [self injectPropertyDependenciesOn:instance withDefinition:definition];
    [self injectCircularDependenciesOn:instance];
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
    if ([instance respondsToSelector:@selector(beforePropertiesSet)])
    {
        [(id <TyphoonPropertyInjectionDelegate>)instance beforePropertiesSet];
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
    [self configureInvocationArgument:invocation toInjectProperty:property onInstance:instance typeDescriptor:typeDescriptor];
    [invocation invoke];
}

- (NSInvocation*)propertySetterInvocationFor:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonInjectedProperty>)property
{
    SEL pSelector = [instance setterForPropertyWithName:property.name];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[(NSObject*)instance methodSignatureForSelector:pSelector]];
    [invocation setTarget:instance];
    [invocation setSelector:pSelector];
    return invocation;
}

- (void)configureInvocationArgument:(NSInvocation*)invocation toInjectProperty:(id <TyphoonInjectedProperty>)property
        onInstance:(id <TyphoonIntrospectiveNSObject>)instance typeDescriptor:(TyphoonTypeDescriptor*)typeDescriptor;
{
    if (property.injectionType == TyphoonPropertyInjectionTypeByType)
    {
        TyphoonDefinition* definition = [self definitionForType:[typeDescriptor classOrProtocol]];

        [self evaluateCircularDependency:definition.key propertyName:property.name instance:instance];
        if ([self propertyIsCircular:property onInstance:instance])
        {
            return;
        }

        id reference = [self componentForKey:definition.key];
        [invocation setArgument:&reference atIndex:2];
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeByReference)
    {
        TyphoonPropertyInjectedByReference* byReference = (TyphoonPropertyInjectedByReference*)property;
        [self evaluateCircularDependency:byReference.reference propertyName:property.name instance:instance];

        if ([self propertyIsCircular:property onInstance:instance])
        {
            return;
        }

        id reference = [self componentForKey:byReference.reference];
        [invocation setArgument:&reference atIndex:2];
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeAsStringRepresentation)
    {
        TyphoonPropertyInjectedWithStringRepresentation* valueProperty = (TyphoonPropertyInjectedWithStringRepresentation*)property;
        [self setArgumentFor:invocation index:2 textValue:valueProperty.textValue requiredType:typeDescriptor];
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeAsCollection)
    {
        id collection = [self buildCollectionFor:(TyphoonPropertyInjectedAsCollection*)property instance:instance];
        [invocation setArgument:&collection atIndex:2];
    }
    else if (property.injectionType == TyphoonPropertyInjectionTypeAsObjectInstance)
    {
        TyphoonPropertyInjectedAsObjectInstance* byInstance = (TyphoonPropertyInjectedAsObjectInstance*)property;
        id value = byInstance.objectInstance;
        [invocation setArgument:&value atIndex:2];
    }
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

- (BOOL)propertyIsCircular:(id <TyphoonInjectedProperty>)property onInstance:(id <TyphoonIntrospectiveNSObject>)instance;
{
    return [[instance circularDependentProperties] objectForKey:property.name] != nil;
}

- (void)configureInvocation:(NSInvocation*)invocation toInjectByReferenceProperty:(TyphoonPropertyInjectedByReference*)byReference;
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
                    * invocation = [NSInvocation invocationWithMethodSignature:[(NSObject*)instance methodSignatureForSelector:pSelector]];
            [invocation setTarget:instance];
            [invocation setSelector:pSelector];
            NSString* componentKey = [circularDependentProperties objectForKey:propertyName];
            id reference = [_currentlyResolvingReferences peekInstanceForKey:componentKey];
            [invocation setArgument:&reference atIndex:2];
            [invocation invoke];
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
            [invocation setArgument:&value atIndex:parameter.index + 2];
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
* TODO: Generic fix for any object that returns a new instance from init, after alloc.
* NSManagedObjectModelReturns a different pointer from init than from alloc, Typhoon+ARC is not currently picking this up.
*/
- (void)handleSpecialCaseForNSManagedObjectModel:(id)instance
{
    if ([instance isKindOfClass:[NSManagedObjectModel class]])
    {
        int retainCount = objc_msgSend(instance, NSSelectorFromString(@"retainCount"));
        LogInfo("FixMe: Ensuring NSManagedObjectModel is not over-released. Current retain count: %i", retainCount);
        objc_msgSend(instance, NSSelectorFromString(@"retain"));

    }
}


@end
