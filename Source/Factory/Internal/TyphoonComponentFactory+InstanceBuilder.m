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
#import "TyphoonInstancePostProcessor.h"
#import "TyphoonStackElement.h"
#import "NSObject+PropertyInjection.h"
#import "NSInvocation+TCFInstanceBuilder.h"
#import "TyphoonInjectionContext.h"
#import "TyphoonPropertyInjection.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonDefinitionAutoInjectionPostProcessor.h"
#import "TyphoonFactoryDefinition.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"

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

    instance = [self postProcessInstance:instance definition:definition];
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
    TyphoonInjectionContext *context = [[TyphoonInjectionContextPool shared] dequeueReusableContext];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = YES;
    context.destinationInstanceClass = clazz;

    __block NSInvocation *result;
    [method createInvocationOnClass:clazz withContext:context completion:^(NSInvocation *invocation) {
        result = invocation;
        [[TyphoonInjectionContextPool shared] enqueueReusableContext:context];
    }];
    return result;
}

- (id)postProcessInstance:(id)instance definition:(TyphoonDefinition *)definition
{
    if (![instance conformsToProtocol:@protocol(TyphoonInstancePostProcessor)]) {
        for (id <TyphoonInstancePostProcessor> postProcessor in _componentPostProcessors) {
            instance = [postProcessor postProcessComponent:instance withDefinition:definition];
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
    TyphoonInjectionContext *context = [[TyphoonInjectionContextPool shared] dequeueReusableContext];
    context.destinationInstanceClass = [instance class];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = NO;

    [method createInvocationOnClass:[instance class] withContext:context completion:^(NSInvocation *invocation) {
        [invocation invokeWithTarget:instance];
        [[TyphoonInjectionContextPool shared] enqueueReusableContext:context];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Property Injection
//-------------------------------------------------------------------------------------------

- (void)doPropertyInjectionOn:(id)instance property:(id <TyphoonPropertyInjection>)property args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [[TyphoonInjectionContextPool shared] dequeueReusableContext];
    context.destinationType = [instance typhoon_typeForPropertyWithName:property.propertyName];
    context.destinationInstanceClass = [instance class];
    context.factory = self;
    context.args = args;
    context.raiseExceptionIfCircular = NO;

    [property valueToInjectWithContext:context completion:^(id value) {
        [instance typhoon_injectValue:value forPropertyName:property.propertyName];
        [[TyphoonInjectionContextPool shared] enqueueReusableContext:context];
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
        if (IsClass(classOrProtocol) && [self hasAnnotationsForClass:classOrProtocol]) {
            return [self autoDefinitionForClass:classOrProtocol];
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

//-------------------------------------------------------------------------------------------
#pragma mark - AutoInjection Definition
//-------------------------------------------------------------------------------------------

- (BOOL)hasAnnotationsForClass:(Class)clazz
{
    return [[self autoInjectionPostProcessor] hasAnnotationForClass:clazz];
}

- (TyphoonDefinition *)autoDefinitionForClass:(Class)clazz
{
    NSString *key = [self definitionKeyForAutoDefinitionForClass:clazz];

    TyphoonDefinition *definition = [self definitionForKey:key];
    if (!definition) {
        definition = [TyphoonDefinition withClass:clazz key:key];
        [self applyPostProcessorsToDefinition:definition];
        [self registerDefinition:definition];
    }

    return definition;
}

- (NSString *)definitionKeyForAutoDefinitionForClass:(Class)clazz
{
    return [NSString stringWithFormat:@"__auto_definition_for_%@__", NSStringFromClass(clazz)];
}

- (TyphoonDefinitionAutoInjectionPostProcessor *)autoInjectionPostProcessor
{
    TyphoonDefinitionAutoInjectionPostProcessor *postProcessor = nil;
    for (id<TyphoonDefinitionPostProcessor> item in _definitionPostProcessors) {
        if ([item isMemberOfClass:[TyphoonDefinitionAutoInjectionPostProcessor class]]) {
            postProcessor = item;
            break;
        }
    }
    return postProcessor;
}


- (TyphoonDefinition *)applyPostProcessorsToDefinition:(TyphoonDefinition *)definition
{
    for (id<TyphoonDefinitionPostProcessor>postProcessor in _definitionPostProcessors) {
        TyphoonDefinition *replacement = nil;
        [postProcessor postProcessDefinition:definition replacement:&replacement];
        if (replacement) {
            definition = replacement;
        }
    }
    definition.postProcessed = YES;
    return definition;
}

@end
