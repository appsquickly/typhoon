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
#import "TyphoonDefinition+Infrastructure.h"
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
    return [definition initializeInstanceWithArgs:args factory:self];
}

- (void)doInjectionEventsOn:(id)instance withDefinition:(TyphoonDefinition *)definition
                       args:(TyphoonRuntimeArguments *)args
{
    if ([instance respondsToSelector:@selector(typhoonWillInject)]) {
        [instance typhoonWillInject];
    }
    
    [definition doInjectionEventsOn:instance withArgs:args factory:self];

    [_stack notifyOnceWhenStackEmptyUsingBlock:^{
        [definition doAfterAllInjectionsOn:instance];

        [self injectAssemblyOnInstanceIfTyphoonAware:instance];

        if ([instance respondsToSelector:@selector(typhoonDidInject)]) {
            [instance typhoonDidInject];
        }
    }];
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
        [result applyGlobalNamespace];
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
