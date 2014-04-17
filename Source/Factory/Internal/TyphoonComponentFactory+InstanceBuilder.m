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
    TyphoonStackElement *stackElement = [TyphoonStackElement elementWithKey:definition.key args:args];
    [_stack push:stackElement];

    id instance = [self initializeInstanceWithDefinition:definition args:args];

    [stackElement takeInstance:instance];

    [self doInjectionEventsOn:instance withDefinition:definition args:args];

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
    
    NSInvocation *invocation = [self invocationToInit:instanceClass with:initializer args:args];
    
    BOOL isClassMethod = [initializer isClassMethodOnClass:instanceClass];

    if (isClass && !isClassMethod) {
        result = [invocation typhoon_resultOfInvokingOnAllocationForClass:instanceClass];
    }
    else {
        result = [invocation typhoon_resultOfInvokingOnInstance:instanceOrClass];
    }
    
    return result;
}

- (NSInvocation *)invocationToInit:(Class)clazz with:(TyphoonMethod *)method args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [TyphoonInjectionContext new];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = YES;
    
    __block NSInvocation *result;
    [method createInvocationOnClass:clazz withContext:context completion:^(NSInvocation *invocation) {
        result = invocation;
    }];
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

- (id)buildSharedInstanceForDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    id instance = [_stack peekForKey:definition.key args:args].instance;
    if (instance) {
        return instance;
    }
    return [self buildInstanceWithDefinition:definition args:args];
}

/* ====================================================================================================================================== */
#pragma mark - Methods Injection

- (void)doMethodInjection:(TyphoonMethod *)method onInstance:(id)instance args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [TyphoonInjectionContext new];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = NO;
    
    [method createInvocationOnClass:[instance class] withContext:context completion:^(NSInvocation *invocation) {
        [invocation invokeWithTarget:instance];
    }];
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)doInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    [self doBeforeInjectionsOn:instance withDefinition:definition];

    for (id <TyphoonPropertyInjection> property in [definition injectedProperties]) {
        [self doPropertyInjectionIfNeededOn:instance property:property args:args];
    }
    
    for (TyphoonMethod *method in [definition injectedMethods]) {
        [self doMethodInjection:method onInstance:instance args:args];
    }

    [self injectAssemblyOnInstanceIfTyphoonAware:instance];

    [self doAfterInjectionsOn:instance withDefinition:definition];
}

- (void)doBeforeInjectionsOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition *)definition
{
    if ([instance respondsToSelector:@selector(beforePropertiesSet)]) {
        [(id <TyphoonPropertyInjectionDelegate>) instance beforePropertiesSet];
    }

    if ([instance respondsToSelector:definition.beforeInjections]) {
        void(*method)(id, SEL) = (void *)[(NSObject *)instance methodForSelector:definition.beforeInjections];
        method(instance, definition.beforeInjections);
    }
}

- (void)doPropertyInjectionIfNeededOn:(id <TyphoonIntrospectiveNSObject, TyphoonPropertyInjectionInternalDelegate>)instance property:(id <TyphoonPropertyInjection>)property
                                 args:(TyphoonRuntimeArguments *)args
{
    //TODO: Refactor this method and 'shouldInjectProperty:withType:lazyValue:' with lazyValue
    if ([instance respondsToSelector:@selector(shouldInjectProperty:withType:lazyValue:)]) {
        TyphoonTypeDescriptor *propertyType = [instance typhoon_typeForPropertyWithName:property.propertyName];
        
        TyphoonPropertyInjectionLazyValue lazyValue = ^id {
            TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] init];
            context.destinationType = propertyType;
            context.factory = self;
            context.args = args;
            context.raiseExceptionIfCircular = YES;
            __block id result = nil;
            [property valueToInjectWithContext:context completion:^(id value) {
                result = value;
            }];
            return result;
        };
        
        if ([instance shouldInjectProperty:property withType:propertyType lazyValue:lazyValue]) {
            [self doPropertyInjection:instance property:property args:args];
        }
    } else {
        [self doPropertyInjection:instance property:property args:args];
    }
}

- (void)doPropertyInjection:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonPropertyInjection>)property
    args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] init];
    context.destinationType = [instance typhoon_typeForPropertyWithName:property.propertyName];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = NO;

    [property valueToInjectWithContext:context completion:^(id value) {
        [(NSObject *)instance typhoon_injectValue:value forPropertyName:property.propertyName];
    }];
}

- (void)resolveCircularDependency:(NSString *)key args:(TyphoonRuntimeArguments *)args resolvedBlock:(void(^)(BOOL isCircular))resolvedBlock
{
    TyphoonStackElement *element = [_stack peekForKey:key args:args];
    if (element) {
        [element addInstanceCompleteBlock:^(id instance) {
            resolvedBlock(YES);
        }];
    } else {
        resolvedBlock(NO);
    }
}

- (void)doAfterInjectionsOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition *)definition
{
    if ([instance respondsToSelector:@selector(afterPropertiesSet)]) {
        [(id <TyphoonPropertyInjectionDelegate>) instance afterPropertiesSet];
    }

    if ([instance respondsToSelector:definition.afterInjections]) {
        void(*method)(id, SEL) = (void *)[(NSObject *)instance methodForSelector:definition.afterInjections];
        method(instance, definition.afterInjections);
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
        [NSException raise:NSInvalidArgumentException format:@"More than one component is defined satisfying type: '%@'", TyphoonTypeStringFor(classOrProtocol)];
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
