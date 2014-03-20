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
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonMethod.h"
#import "TyphoonCallStack.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonPropertyInjectionDelegate.h"
#import "TyphoonPropertyInjectionInternalDelegate.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"
#import "TyphoonComponentFactoryAware.h"
#import "TyphoonComponentPostProcessor.h"
#import "TyphoonStackElement.h"
#import "NSObject+PropertyInjection.h"
#import "NSInvocation+TCFInstanceBuilder.h"

#define AssertTypeDescriptionForPropertyOnInstance(type, property, instance) if (!type) [NSException raise:@"NSUnknownKeyException" \
format:@"Tried to inject property '%@' on object of type '%@', but the instance has no setter for this property.",property.propertyName, [instance class]]


@implementation TyphoonComponentFactory (InstanceBuilder)

- (TyphoonCallStack *)stack
{
    return _stack;
}

- (id)buildInstanceWithDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{

    TyphoonStackElement *stackElement = [TyphoonStackElement elementWithKey:definition.key];
    [_stack push:stackElement];

    id instance = [self initializeInstanceWithDefinition:definition args:args];

    [stackElement takeInstance:instance];

    [self doPropertyInjectionEventsOn:instance withDefinition:definition args:args];

    instance = [self postProcessInstance:instance];
    [_stack pop];

    return instance;
}

- (id)initializeInstanceWithDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    id instance = nil;

    if (definition.factory) {
        id factoryComponent = [self componentForKey:definition.factory.key];
        instance = [self resultOfInvocationInitializer:definition.initializer on:factoryComponent withArgs:args];
    }
    else {
        instance = [self resultOfInvocationInitializer:definition.initializer on:definition.type withArgs:args];
    }

    return instance;
}

- (id)resultOfInvocationInitializer:(TyphoonMethod *)initializer on:(id)instanceOrClass withArgs:(TyphoonRuntimeArguments *)args
{
    id result;
    
    BOOL isClass = class_isMetaClass(object_getClass(instanceOrClass));
    Class instanceClass = isClass ? instanceOrClass : [instanceOrClass class];
    
    NSInvocation *invocation = [initializer newInvocationOnClass:instanceClass withFactory:self args:args];
    
    BOOL isClassMethod = [initializer isClassMethodOnClass:instanceClass];

    if (isClass && !isClassMethod) {
        result = [invocation typhoon_resultOfInvokingOnAllocationForClass:instanceClass];
    }
    else {
        result = [invocation typhoon_resultOfInvokingOnInstance:instanceOrClass];
    }
    
    return result;
}

- (id)postProcessInstance:(id)instance
{
    if (![instance conformsToProtocol:@protocol(TyphoonComponentPostProcessor)]) {
        for (id <TyphoonComponentPostProcessor> postProcessor in _componentPostProcessors) {
            instance = [postProcessor postProcessComponent:instance];
        }
    }
    return instance;
}

- (void)injectAssemblyOnInstanceIfTyphoonAware:(id)instance
{

    if ([instance conformsToProtocol:@protocol(TyphoonComponentFactoryAware)]) {
        [self injectAssemblyOnInstance:instance];
    }
}

- (void)injectAssemblyOnInstance:(id <TyphoonComponentFactoryAware>)instance
{
    [instance setFactory:self];
}

- (id)buildSharedInstanceForDefinition:(TyphoonDefinition *)definition
{
    id instance = [_stack peekForKey:definition.key].instance;
    if (instance) {
        return instance;
    }
    return [self buildInstanceWithDefinition:definition args:nil];
}

/* ====================================================================================================================================== */
#pragma mark - Methods Injection

- (void)doMethodsInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    for (TyphoonMethod *method in [definition injectedMethods]) {
        NSInvocation *invocation = [method newInvocationOnClass:[instance class] withFactory:self args:args];
        [invocation invokeWithTarget:instance];
    }
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)doPropertyInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    [self doBeforePropertyInjectionOn:instance withDefinition:definition];

    for (id <TyphoonPropertyInjection> property in [definition injectedProperties]) {
        [self doPropertyInjection:instance property:property args:args];
    }
    
    [self doMethodsInjectionEventsOn:instance withDefinition:definition args:args];

    [self injectAssemblyOnInstanceIfTyphoonAware:instance];
    [self injectCircularDependenciesOn:instance];

    [self doAfterPropertyInjectionOn:instance withDefinition:definition];
}

- (void)doBeforePropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition *)definition
{
    if ([instance respondsToSelector:@selector(beforePropertiesSet)]) {
        [(id <TyphoonPropertyInjectionDelegate>) instance beforePropertiesSet];
    }

    if ([instance respondsToSelector:definition.beforePropertyInjection]) {
        objc_msgSend(instance, definition.beforePropertyInjection);
    }
}

- (void)doPropertyInjection:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonPropertyInjection>)property
    args:(TyphoonRuntimeArguments *)args
{
    TyphoonTypeDescriptor *propertyType = [instance typhoon_typeForPropertyWithName:property.propertyName];
    AssertTypeDescriptionForPropertyOnInstance(propertyType, property, instance);

    TyphoonPropertyInjectionLazyValue lazyValue = ^id {
        return [property valueToInjectPropertyOnInstance:instance withFactory:self args:args];
    };

    if (![instance respondsToSelector:@selector(shouldInjectProperty:withType:lazyValue:)] ||
        [(id <TyphoonPropertyInjectionInternalDelegate>) instance shouldInjectProperty:property withType:propertyType
            lazyValue:lazyValue]) {
        id valueToInject = lazyValue();

        if (valueToInject) {
            [(NSObject *) instance injectValue:valueToInject forPropertyName:property.propertyName withType:propertyType];
        }
    }
}


- (void)evaluateCircularDependency:(NSString *)componentKey propertyName:(NSString *)propertyName
    instance:(id <TyphoonIntrospectiveNSObject>)instance
{

    if ([_stack isResolvingKey:componentKey]) {
        NSDictionary *circularDependencies = [instance typhoon_circularDependentProperties];
        [circularDependencies setValue:componentKey forKey:propertyName];
        LogTrace(@"Circular dependency detected: %@", [instance typhoon_circularDependentProperties]);
    }
}

- (BOOL)isCircularPropertyWithName:(NSString *)name onInstance:(id <TyphoonIntrospectiveNSObject>)instance
{
    return [[instance typhoon_circularDependentProperties] objectForKey:name] != nil;
}

- (void)injectCircularDependenciesOn:(id <TyphoonIntrospectiveNSObject>)instance
{
    NSMutableDictionary *circularDependentProperties = [instance typhoon_circularDependentProperties];
    for (NSString *propertyName in [circularDependentProperties allKeys]) {
        id propertyValue = [(NSObject *) instance valueForKey:propertyName];
        if (!propertyValue) {
            NSString *componentKey = [circularDependentProperties objectForKey:propertyName];
            [[_stack peekForKey:componentKey] addInstanceCompleteBlock:^(id reference) {
                [(NSObject *) instance setValue:reference forKey:propertyName];
            }];
        }
    }
}

- (void)doAfterPropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition *)definition
{
    if ([instance respondsToSelector:@selector(afterPropertiesSet)]) {
        [(id <TyphoonPropertyInjectionDelegate>) instance afterPropertiesSet];
    }

    if ([instance respondsToSelector:definition.afterPropertyInjection]) {
        objc_msgSend(instance, definition.afterPropertyInjection);
    }
}

#pragma mark - End Property Injection

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (TyphoonDefinition *)definitionForType:(id)classOrProtocol
{
    NSArray *candidates = [self allDefinitionsForType:classOrProtocol];

    if ([candidates count] == 0) {

        SEL autoInjectedProperties = sel_registerName("typhoonAutoInjectedProperties");
        if (class_isMetaClass(object_getClass(classOrProtocol)) && [classOrProtocol respondsToSelector:autoInjectedProperties]) {
            LogTrace(@"Class %@ wants auto-wiring. . . registering.", NSStringFromClass(classOrProtocol));
            [self registerDefinition:[TyphoonDefinition withClass:classOrProtocol]];
            return [self definitionForType:classOrProtocol];
        }
        [NSException raise:NSInvalidArgumentException format:@"No components defined which satisify type: '%@'",
                                                             TyphoonTypeStringFor(classOrProtocol)];
    }
    if ([candidates count] > 1) {
        [NSException raise:NSInvalidArgumentException format:@"More than one component is defined satisfying type: '%@'", classOrProtocol];
    }
    return [candidates objectAtIndex:0];
}


- (NSArray *)allDefinitionsForType:(id)classOrProtocol
{

    NSMutableArray *results = [[NSMutableArray alloc] init];
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));

    for (TyphoonDefinition *definition in _registry) {
        if (isClass) {
            if (definition.type == classOrProtocol || [definition.type isSubclassOfClass:classOrProtocol]) {
                [results addObject:definition];
            }
        }
        else {
            if ([definition.type conformsToProtocol:classOrProtocol]) {
                [results addObject:definition];
            }
        }
    }
    return [results copy];
}

@end
