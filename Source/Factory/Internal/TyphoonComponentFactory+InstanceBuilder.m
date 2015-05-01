////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Typhoon/Typhoon.h>
#import <Typhoon/TyphoonInstancePostProcessor.h>
#import "TyphoonLinkerCategoryBugFix.h"
#import "TyphoonInjectionContext.h"
#import "TyphoonDefinition+InstanceBuilder.h"

TYPHOON_LINK_CATEGORY(TyphoonComponentFactory_InstanceBuilder)

#import "TyphoonCallStack.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonStackElement.h"
#import "NSObject+PropertyInjection.h"
#import "NSInvocation+TCFInstanceBuilder.h"
#import "TyphoonPropertyInjection.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonFactoryAutoInjectionPostProcessor.h"

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
    __block id instance = [definition targetForInitializerWithFactory:self args:args];
    if (definition.initializer && instance) {
        BOOL isClass = IsClass(instance);

        TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:self args:args
            raiseExceptionIfCircular:YES];
        context.classUnderConstruction = isClass ? (Class)instance : [instance class];;

        [definition.initializer createInvocationWithContext:context completion:^(NSInvocation *invocation) {
            if (isClass && ![definition.initializer isClassMethodOnClass:context.classUnderConstruction]) {
                instance = [invocation typhoon_resultOfInvokingOnAllocationForClass:context.classUnderConstruction];
            } else {
                instance = [invocation typhoon_resultOfInvokingOnInstance:instance];
            }
        }];

    }
    return instance;
}

- (id)postProcessInstance:(id)instance
{
    if (![instance conformsToProtocol:@protocol(TyphoonInstancePostProcessor)]) {
        for (id<TyphoonInstancePostProcessor> postProcessor in _instancePostProcessors) {
            instance = [postProcessor postProcessInstance:instance];
        }
    }
    return instance;
}

- (void)injectAssemblyOnInstanceIfTyphoonAware:(id)instance
{
    if ([instance respondsToSelector:@selector(typhoonSetFactory:)]) {
        [(NSObject *)instance typhoonSetFactory:self];
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

//-------------------------------------------------------------------------------------------
#pragma mark - Injection process
//-------------------------------------------------------------------------------------------

- (void)doInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition
    args:(TyphoonRuntimeArguments *)args
{
    [self doBeforeInjectionsOn:instance withDefinition:definition args:args];

    for (id<TyphoonPropertyInjection> property in [definition injectedProperties]) {
        [self doPropertyInjectionOn:instance property:property args:args];
    }

    for (TyphoonMethod *method in [definition injectedMethods]) {
        [self doMethodInjection:method onInstance:instance args:args];
    }

    [self injectAssemblyOnInstanceIfTyphoonAware:instance];

    [self doAfterInjectionsOn:instance withDefinition:definition args:args];
}

- (void)doBeforeInjectionsOn:(id)instance withDefinition:(TyphoonDefinition *)definition
    args:(TyphoonRuntimeArguments *)args
{
    if ([instance respondsToSelector:@selector(typhoonWillInject)]) {
        [instance typhoonWillInject];
    }

    TyphoonMethod *beforeInjections = [definition beforeInjections];
    if (beforeInjections) {
        [self doMethodInjection:beforeInjections onInstance:instance args:args];
    }
}

- (void)doAfterInjectionsOn:(id)instance withDefinition:(TyphoonDefinition *)definition
    args:(TyphoonRuntimeArguments *)args
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
    TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:self args:args
        raiseExceptionIfCircular:NO];
    context.classUnderConstruction = [instance class];

    [method createInvocationWithContext:context completion:^(NSInvocation *invocation) {
        [invocation invokeWithTarget:instance];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Property Injection
//-------------------------------------------------------------------------------------------

- (void)doPropertyInjectionOn:(id)instance property:(id<TyphoonPropertyInjection>)property
    args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:self args:args
        raiseExceptionIfCircular:NO];
    context.destinationType = [instance typhoonTypeForPropertyNamed:property.propertyName];
    context.classUnderConstruction = [instance class];

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
    } else {
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

- (TyphoonDefinition *)definitionForType:(id)classOrProtocol orNil:(BOOL)returnNilIfNotFound
    includeSubclasses:(BOOL)includeSubclasses
{
    NSArray *candidates = [self allDefinitionsForType:classOrProtocol includeSubclasses:includeSubclasses];

    if ([candidates count] == 0) {

        //Auto registering definition with AutoInjection
        if (IsClass(classOrProtocol)) {
            TyphoonDefinition *autoDefinition = [self autoInjectionDefinitionForClass:classOrProtocol];
            if (autoDefinition) {
                [self registerDefinition:autoDefinition];
                return [self definitionForType:classOrProtocol orNil:returnNilIfNotFound
                    includeSubclasses:includeSubclasses];
            }
        }

        if (returnNilIfNotFound) {
            return nil;
        } else {
            [NSException raise:NSInvalidArgumentException format:@"No components defined which satisify type: '%@'",
                                                                 TyphoonTypeStringFor(classOrProtocol)];
        }
    }
    if ([candidates count] > 1) {
        [NSException raise:NSInvalidArgumentException
            format:@"More than one component is defined satisfying type: '%@' : %@",
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

        if (IsClass(classOrProtocol) && [definition isCandidateForInjectedClass:classOrProtocol
            includeSubclasses:includeSubclasses]) {
            [results addObject:definition];
        } else if (IsProtocol(classOrProtocol) && [definition isCandidateForInjectedProtocol:classOrProtocol]) {
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
    for (id<TyphoonDefinitionPostProcessor> item in _definitionPostProcessors) {
        if ([item isMemberOfClass:[TyphoonFactoryAutoInjectionPostProcessor class]]) {
            postProcessor = item;
            break;
        }
    }
    return postProcessor;
}

@end
