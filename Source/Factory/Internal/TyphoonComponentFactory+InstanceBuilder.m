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
#import "TyphoonInitializer.h"
#import "TyphoonCallStack.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonPropertyInjectionDelegate.h"
#import "TyphoonPropertyInjectionInternalDelegate.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"
#import "TyphoonComponentFactoryAware.h"
#import "TyphoonComponentPostProcessor.h"
#import "TyphoonStackElement.h"
#import "NSObject+PropertyInjection.h"
#import "NSInvocation+TCFInstanceBuilder.h"

#define AssertTypeDescriptionForPropertyOnInstance(type, property, instance) if (!type) [NSException raise:@"NSUnknownKeyException" \
format:@"Tried to inject property '%@' on object of type '%@', but the instance has no setter for this property.",property.name, [instance class]]


@implementation TyphoonComponentFactory (InstanceBuilder)

- (TyphoonCallStack *)stack
{
    return _stack;
}

- (id)buildInstanceWithDefinition:(TyphoonDefinition *)definition
{

    TyphoonStackElement *stackElement = [TyphoonStackElement elementWithKey:definition.key];
    [_stack push:stackElement];

    id instance = [self initializeInstanceWithDefinition:definition];

    [stackElement takeInstance:instance];

    [self doPropertyInjectionEventsOn:instance withDefinition:definition];

    instance = [self postProcessInstance:instance];
    [_stack pop];

    return instance;
}

- (id)initializeInstanceWithDefinition:(TyphoonDefinition *)definition
{
    id initTarget = nil;

    if (definition.factory) {
        initTarget = [self componentForKey:definition.factory.key];
    }
    else if (definition.initializer.isClassMethod) {
        initTarget = definition.type;
    }

    id instance = nil;

    NSInvocation *invocation = [definition.initializer newInvocationInFactory:self];

    if (definition.factory || [definition.initializer isClassMethod]) {
        instance = [invocation typhoon_resultOfInvokingOnInstance:initTarget];
    }
    else {
        instance = [invocation typhoon_resultOfInvokingOnAllocationForClass:definition.type];
    }

    return instance;
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
    return [self buildInstanceWithDefinition:definition];
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)doPropertyInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition
{
    [self doBeforePropertyInjectionOn:instance withDefinition:definition];

    for (TyphoonAbstractInjectedProperty *property in [definition injectedProperties]) {
        [self doPropertyInjection:instance property:property];
    }

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

- (void)doPropertyInjection:(id <TyphoonIntrospectiveNSObject>)instance property:(TyphoonAbstractInjectedProperty *)property
{
    TyphoonTypeDescriptor *propertyType = [instance typeForPropertyWithName:property.name];
    AssertTypeDescriptionForPropertyOnInstance(propertyType, property, instance);

    TyphoonPropertyInjectionLazyValue lazyValue = ^id {
        return [property withFactory:self computeValueToInjectOnInstance:instance];
    };

    if (![instance respondsToSelector:@selector(shouldInjectProperty:withType:lazyValue:)] ||
        [(id <TyphoonPropertyInjectionInternalDelegate>) instance shouldInjectProperty:property withType:propertyType
            lazyValue:lazyValue]) {
        id valueToInject = lazyValue();

        if (valueToInject) {
            [(NSObject *) instance injectValue:valueToInject forPropertyName:property.name withType:propertyType];
        }
    }
}


- (void)evaluateCircularDependency:(NSString *)componentKey propertyName:(NSString *)propertyName
    instance:(id <TyphoonIntrospectiveNSObject>)instance
{

    if ([_stack isResolvingKey:componentKey]) {
        NSDictionary *circularDependencies = [instance circularDependentProperties];
        [circularDependencies setValue:componentKey forKey:propertyName];
        LogTrace(@"Circular dependency detected: %@", [instance circularDependentProperties]);
    }
}

- (BOOL)propertyIsCircular:(TyphoonAbstractInjectedProperty *)property onInstance:(id <TyphoonIntrospectiveNSObject>)instance
{
    return [[instance circularDependentProperties] objectForKey:property.name] != nil;
}

- (void)injectCircularDependenciesOn:(id <TyphoonIntrospectiveNSObject>)instance
{
    NSMutableDictionary *circularDependentProperties = [instance circularDependentProperties];
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
