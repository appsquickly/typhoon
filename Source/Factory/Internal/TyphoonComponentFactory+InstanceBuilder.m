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

#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonCallStack.h"
#import "TyphoonTypeDescriptor.h"
#import "NSObject+FactoryHooks.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"
#import "TyphoonComponentPostProcessor.h"
#import "TyphoonStackElement.h"
#import "NSObject+PropertyInjection.h"
#import "NSInvocation+TCFInstanceBuilder.h"
#import "TyphoonInjectionContext.h"
#import "TyphoonPropertyInjection.h"
#import "NSObject+TyphoonIntrospectionUtils.h"

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
        id factoryComponent = [self componentForKey:[(TyphoonDefinition *)definition.factory key]];
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
    context.destinationInstanceClass = clazz;

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
    if ([instance respondsToSelector:@selector(typhoonSetFactory:)]) {
        [(NSObject *) instance typhoonSetFactory:self];
    }
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
#pragma mark - Injection process

- (void)doInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    [self doBeforeInjectionsOn:instance withDefinition:definition];

    for (id <TyphoonPropertyInjection> property in [definition injectedProperties]) {
        [self doPropertyInjectionOn:instance property:property args:args];
    }

    for (TyphoonMethod *method in [definition injectedMethods]) {
        [self doMethodInjection:method onInstance:instance args:args];
    }

    [self injectAssemblyOnInstanceIfTyphoonAware:instance];

    [self doAfterInjectionsOn:instance withDefinition:definition];
}

- (void)doBeforeInjectionsOn:(id)instance withDefinition:(TyphoonDefinition *)definition
{
    if ([instance respondsToSelector:@selector(typhoonWillInject)]) {
        [instance typhoonWillInject];
    }

    if (definition && [instance respondsToSelector:definition.beforeInjections]) {
        void(*method)(id, SEL) = (void (*)(id, SEL)) [instance methodForSelector:definition.beforeInjections];
        method(instance, definition.beforeInjections);
    }
}

- (void)doAfterInjectionsOn:(id)instance withDefinition:(TyphoonDefinition *)definition
{
    if ([instance respondsToSelector:@selector(typhoonDidInject)]) {
        [instance typhoonDidInject];
    }

    if (definition && [instance respondsToSelector:definition.afterInjections]) {
        void(*method)(id, SEL) = (void (*)(id, SEL)) [instance methodForSelector:definition.afterInjections];
        method(instance, definition.afterInjections);
    }
}

/* ====================================================================================================================================== */
#pragma mark - Methods Injection

- (void)doMethodInjection:(TyphoonMethod *)method onInstance:(id)instance args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [TyphoonInjectionContext new];
    context.destinationInstanceClass = [instance class];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = NO;

    [method createInvocationOnClass:[instance class] withContext:context completion:^(NSInvocation *invocation) {
        [invocation invokeWithTarget:instance];
    }];
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)doPropertyInjectionOn:(id)instance property:(id <TyphoonPropertyInjection>)property args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [TyphoonInjectionContext new];
    context.destinationType = [instance typhoon_typeForPropertyWithName:property.propertyName];
    context.destinationInstanceClass = [instance class];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = NO;

    [property valueToInjectWithContext:context completion:^(id value) {
        [instance typhoon_injectValue:value forPropertyName:property.propertyName];
    }];
}

/* ====================================================================================================================================== */
#pragma mark - Circular dependencies support

- (void)resolveCircularDependency:(NSString *)key args:(TyphoonRuntimeArguments *)args
                    resolvedBlock:(void (^)(BOOL isCircular))resolvedBlock
{
    TyphoonStackElement *element = [_stack peekForKey:key args:args];
    if (element) {
        [element addInstanceCompleteBlock:^(id instance) {
            resolvedBlock(YES);
        }];
    }
    else {
        resolvedBlock(NO);
    }
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (TyphoonDefinition *)definitionForType:(id)classOrProtocol
{
    return [self definitionForType:classOrProtocol orNil:NO includeSubclasses:YES];
}

- (TyphoonDefinition *)definitionForType:(id)classOrProtocol orNil:(BOOL)returnNilIfNotFound includeSubclasses:(BOOL)includeSubclasses
{
    NSArray *candidates = [self allDefinitionsForType:classOrProtocol includeSubclasses:includeSubclasses];

    if ([candidates count] == 0) {

        SEL autoInjectedProperties = sel_registerName("typhoonAutoInjectedProperties");
        if (class_isMetaClass(object_getClass(classOrProtocol)) && [classOrProtocol respondsToSelector:autoInjectedProperties]) {
            LogTrace(@"Class %@ wants auto-wiring. . . registering.", NSStringFromClass(classOrProtocol));
            [self registerDefinition:[TyphoonDefinition withClass:classOrProtocol]];
            return [self definitionForType:classOrProtocol orNil:returnNilIfNotFound includeSubclasses:includeSubclasses];
        }
        if (returnNilIfNotFound) {
            return nil;
        } else {
            [NSException raise:NSInvalidArgumentException format:@"No components defined which satisify type: '%@'", TyphoonTypeStringFor(classOrProtocol)];
        }
    }
    if ([candidates count] > 1) {
        [NSException raise:NSInvalidArgumentException format:@"More than one component is defined satisfying type: '%@' : %@",
                                                             TyphoonTypeStringFor(classOrProtocol), candidates];
    }
    return [candidates objectAtIndex:0];
}



- (NSArray *)allDefinitionsForType:(id)classOrProtocol
{
    return [self allDefinitionsForType:classOrProtocol includeSubclasses:YES];
}

- (NSArray *)allDefinitionsForType:(id)classOrProtocol includeSubclasses:(BOOL)includeSubclasses
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
    BOOL isProtocol = object_getClass(classOrProtocol) == object_getClass(@protocol(NSObject));
    if (!isClass && !isProtocol) {
        [NSException raise:NSInternalInconsistencyException format:@"%@ is not class or protocol", classOrProtocol];
    }

    for (TyphoonDefinition *definition in _registry) {
        if (isClass) {
            BOOL isSameClass = definition.type == classOrProtocol;
            BOOL isSubclass = includeSubclasses && [definition.type isSubclassOfClass:classOrProtocol];
            if (isSameClass || isSubclass) {
                [results addObject:definition];
            }
        }
        else {
            if ([definition.type conformsToProtocol:classOrProtocol]) {
                [results addObject:definition];
            }
        }
    }
    return results;
}

@end
