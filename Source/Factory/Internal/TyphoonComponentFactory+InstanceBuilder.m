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

#import "TyphoonDefinition+Infrastructure.h"
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
#import "TyphoonFactoryAutoInjectionPostProcessor.h"
#import "TyphoonFactoryDefinition.h"

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
    id instance = [definition targetForInitializerWithFactory:self args:args];
    if (definition.initializer) {
        instance = [self resultOfInvocationInitializer:definition.initializer on:instance withArgs:args];
    }
    return instance;
}

- (id)resultOfInvocationInitializer:(TyphoonMethod *)initializer on:(id)instanceOrClass withArgs:(TyphoonRuntimeArguments *)args
{
    id result;

    BOOL isClass = IsClass(instanceOrClass);
    Class instanceClass = isClass ? (Class) instanceOrClass : [instanceOrClass class];

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

- (void)registerInstance:(id)instance asSingletonForDefinition:(TyphoonDefinition *)definition
{
    if (definition.scope == TyphoonScopeSingleton || definition.scope == TyphoonScopeLazySingleton) {
        [_singletons setObject:instance forKey:definition.key];
    } else if (definition.scope == TyphoonScopeWeakSingleton) {
        [_weakSingletons setObject:instance forKey:definition.key];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Injection process
//-------------------------------------------------------------------------------------------

- (void)doInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    [self doBeforeInjectionsOn:instance withDefinition:definition args:args];

    for (id <TyphoonPropertyInjection> property in [definition injectedProperties]) {
        [self doPropertyInjectionOn:instance property:property args:args];
    }

    for (TyphoonMethod *method in [definition injectedMethods]) {
        [self doMethodInjection:method onInstance:instance args:args];
    }

    [self injectAssemblyOnInstanceIfTyphoonAware:instance];

    [self doAfterInjectionsOn:instance withDefinition:definition args:args];
}

- (void)doBeforeInjectionsOn:(id)instance withDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    if ([instance respondsToSelector:@selector(typhoonWillInject)]) {
        [instance typhoonWillInject];
    }

    TyphoonMethod *beforeInjections = [definition beforeInjections];
    if (beforeInjections) {
        [self doMethodInjection:beforeInjections onInstance:instance args:args];
    }
}

- (void)doAfterInjectionsOn:(id)instance withDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    if ([instance respondsToSelector:@selector(typhoonDidInject)]) {
        [instance typhoonDidInject];
    }

    TyphoonMethod *afterInjections = [definition afterInjections];
    if (afterInjections) {
        [self doMethodInjection:afterInjections onInstance:instance args:args];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Methods Injection
//-------------------------------------------------------------------------------------------

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

//-------------------------------------------------------------------------------------------
#pragma mark - Property Injection
//-------------------------------------------------------------------------------------------

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

//-------------------------------------------------------------------------------------------
#pragma mark - Circular dependencies support
//-------------------------------------------------------------------------------------------

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

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (TyphoonDefinition *)definitionForType:(id)classOrProtocol
{
    return [self definitionForType:classOrProtocol orNil:NO includeSubclasses:YES];
}

- (TyphoonDefinition *)definitionForType:(id)classOrProtocol orNil:(BOOL)returnNilIfNotFound includeSubclasses:(BOOL)includeSubclasses
{
    NSArray *candidates = [self allDefinitionsForType:classOrProtocol includeSubclasses:includeSubclasses];

    if ([candidates count] == 0) {

        //Auto registering definition with AutoInjection
        if (IsClass(classOrProtocol)) {
            TyphoonDefinition *autoDefinition = [self autoInjectionDefinitionForClass:classOrProtocol];
            if (autoDefinition) {
                [self registerDefinition:autoDefinition];
                return [self definitionForType:classOrProtocol orNil:returnNilIfNotFound includeSubclasses:includeSubclasses];
            }
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
    return [candidates firstObject];
}

- (NSArray *)allDefinitionsForType:(id)classOrProtocol
{
    return [self allDefinitionsForType:classOrProtocol includeSubclasses:YES];
}

- (NSArray *)allDefinitionsForType:(id)classOrProtocol includeSubclasses:(BOOL)includeSubclasses
{
    if (!IsClass(classOrProtocol) && !IsProtocol(classOrProtocol)) {
        [NSException raise:NSInternalInconsistencyException format:@"%@ is not class or protocol", classOrProtocol];
    }

    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (TyphoonDefinition *definition in _registry) {
        if ([definition matchesAutoInjectionWithType:classOrProtocol includeSubclasses:includeSubclasses]) {
            [results addObject:definition];
        }
    }
    return results;
}

- (TyphoonDefinition *)autoInjectionDefinitionForClass:(Class)clazz
{
    TyphoonDefinition *result = nil;

    TyphoonFactoryAutoInjectionPostProcessor *postProcessor = [self autoInjectionPostProcessor];
    NSArray *properties = [postProcessor autoInjectedPropertiesForClass:clazz];
    if (properties) {
        result = [TyphoonDefinition withClass:clazz];
        for (id propertyInjection in properties) {
            [result addInjectedPropertyIfNotExists:propertyInjection];
        }
    }

    return result;
}

- (TyphoonFactoryAutoInjectionPostProcessor *)autoInjectionPostProcessor
{
    TyphoonFactoryAutoInjectionPostProcessor *postProcessor = nil;
    for (id<TyphoonComponentFactoryPostProcessor> item in _factoryPostProcessors) {
        if ([item isMemberOfClass:[TyphoonFactoryAutoInjectionPostProcessor class]]) {
            postProcessor = item;
            break;
        }
    }
    return postProcessor;
}

@end
