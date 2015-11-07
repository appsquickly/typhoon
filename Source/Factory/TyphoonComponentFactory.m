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


#import <objc/runtime.h>
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "OCLogTemplate.h"
#import "TyphoonDefinitionRegisterer.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonOrdered.h"
#import "TyphoonCallStack.h"
#import "TyphoonParentReferenceHydratingPostProcessor.h"
#import "TyphoonFactoryPropertyInjectionPostProcessor.h"
#import "TyphoonInstancePostProcessor.h"
#import "TyphoonWeakComponentsPool.h"
#import "TyphoonFactoryAutoInjectionPostProcessor.h"
#import "TyphoonStackElement.h"
#import "TyphoonTypeConverterRegistry.h"

@interface TyphoonDefinition (TyphoonComponentFactory)

@property (nonatomic, strong) NSString *key;

@end

@implementation TyphoonComponentFactory

static TyphoonComponentFactory *defaultFactory;

static TyphoonComponentFactory *uiResolvingFactory = nil;

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//-------------------------------------------------------------------------------------------

+ (id)defaultFactory
{
    return defaultFactory;
}

+ (void)setFactoryForResolvingUI:(TyphoonComponentFactory *)factory
{
    uiResolvingFactory = factory;
}

+ (TyphoonComponentFactory *)factoryForResolvingUI
{
    return uiResolvingFactory;
}

+ (TyphoonComponentFactory *)factoryForResolvingFromXibs
{
    return uiResolvingFactory;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableArray alloc] init];
        _singletons = (id<TyphoonComponentsPool>)[[NSMutableDictionary alloc] init];
        _weakSingletons = [TyphoonWeakComponentsPool new];
        _objectGraphSharedInstances = (id<TyphoonComponentsPool>)[[NSMutableDictionary alloc] init];
        _stack = [TyphoonCallStack stack];
        _typeConverterRegistry = [[TyphoonTypeConverterRegistry alloc] init];
        _definitionPostProcessors = [[NSMutableArray alloc] init];
        _instancePostProcessors = [[NSMutableArray alloc] init];
        [self attachDefinitionPostProcessor:[TyphoonParentReferenceHydratingPostProcessor new]];
        [self attachAutoInjectionPostProcessorIfNeeded];
        [self attachDefinitionPostProcessor:[TyphoonFactoryPropertyInjectionPostProcessor new]];
    }
    return self;
}

- (void)attachAutoInjectionPostProcessorIfNeeded
{
    NSDictionary *bundleInfoDictionary = [[NSBundle mainBundle] infoDictionary];

    NSNumber *value = bundleInfoDictionary[@"TyphoonAutoInjectionEnabled"];
    if (!value || [value boolValue]) {
        [self attachDefinitionPostProcessor:[TyphoonFactoryAutoInjectionPostProcessor new]];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (NSArray *)singletons
{
    return [[_singletons allValues] copy];
}

- (void)load
{
    @synchronized (self) {
        if (!_isLoading && ![self isLoaded]) {
            // ensure that the method won't be call recursively.
            _isLoading = YES;

            [self _load];

            _isLoading = NO;
            [self setLoaded:YES];
        }
    }
}

- (void)unload
{
    @synchronized (self) {
        if ([self isLoaded]) {
            NSAssert([_stack isEmpty],
                    @"Stack should be empty when unloading factory. Please finish all object creation before factory unloading");
            [_singletons removeAllObjects];
            [_weakSingletons removeAllObjects];
            [_objectGraphSharedInstances removeAllObjects];
            [self setLoaded:NO];
        }
    }
}

- (void)registerDefinition:(TyphoonDefinition *)definition
{
    if (_isLoading || [self isLoaded]) {
        definition = [self definitionAfterApplyingPostProcessorsToDefinition:definition];
    }
    
    TyphoonDefinitionRegisterer
            *registerer = [[TyphoonDefinitionRegisterer alloc] initWithDefinition:definition componentFactory:self];
    [registerer doRegistration];

    if ([self isLoaded]) {
        [self instantiateIfEagerSingleton:definition];
    }
}

- (id)objectForKeyedSubscript:(id)key
{
    if ([key isKindOfClass:[NSString class]]) {
        return [self componentForKey:key];
    }
    return [self componentForType:key];
}

- (id)componentForType:(id)classOrProtocol
{
    [self loadIfNeeded];
    return [self newOrScopeCachedInstanceForDefinition:[self definitionForType:classOrProtocol] args:nil];
}

- (NSArray *)allComponentsForType:(id)classOrProtocol
{
    [self loadIfNeeded];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSArray *definitions = [self allDefinitionsForType:classOrProtocol];
    for (TyphoonDefinition *definition in definitions) {
        [results addObject:[self newOrScopeCachedInstanceForDefinition:definition args:nil]];
    }
    return [results copy];
}

- (id)componentForKey:(NSString *)key
{
    return [self componentForKey:key args:nil];
}

- (id)componentForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    if (!key) {
        return nil;
    }

    [self loadIfNeeded];

    TyphoonDefinition *definition = [self definitionForKey:key];
    if (!definition) {
        [NSException raise:NSInvalidArgumentException format:@"No component matching id '%@'.", key];
    }

    return [self newOrScopeCachedInstanceForDefinition:definition args:args];
}

- (void)loadIfNeeded
{
    if (![self isLoaded]) {
        [self load];
    }
}

- (void)makeDefault
{
    @synchronized (self) {
        if (defaultFactory) {
            LogInfo(@"*** Warning *** overriding current default factory.");
        }
        defaultFactory = self;
    }
}

- (TyphoonTypeConverterRegistry *)typeConverterRegistry {
    return _typeConverterRegistry;
}

- (NSArray *)registry
{
    [self loadIfNeeded];

    return [_registry copy];
}

- (void)enumerateDefinitions:(void (^)(TyphoonDefinition *definition, NSUInteger index, TyphoonDefinition **definitionToReplace,
        BOOL *stop))block
{
    [self loadIfNeeded];

    for (NSUInteger i = 0; i < [_registry count]; i++) {
        TyphoonDefinition *definition = _registry[i];
        TyphoonDefinition *definitionToReplace = nil;
        BOOL stop = NO;
        block(definition, i, &definitionToReplace, &stop);
        if (definitionToReplace) {
            _registry[i] = definitionToReplace;
        }
        if (stop) {
            break;
        }
    }
}

- (void)attachDefinitionPostProcessor:(id<TyphoonDefinitionPostProcessor>)postProcessor {
    LogTrace(@"Attaching definition post processor: %@", postProcessor);
    [_definitionPostProcessors addObject:postProcessor];
    if ([self isLoaded]) {
        LogDebug(@"Definitions registered, refreshing all singletons.");
        [self unload];
    }
}

- (void)attachInstancePostProcessor:(id<TyphoonInstancePostProcessor>)postProcessor {
    LogTrace(@"Attaching instance post processor: %@", postProcessor);
    [_instancePostProcessors addObject:postProcessor];
}

- (void)attachTypeConverter:(id<TyphoonTypeConverter>)typeConverter {
    LogTrace(@"Attaching type conveter: %@", typeConverter);
    [_typeConverterRegistry registerTypeConverter:typeConverter];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)attachPostProcessor:(id<TyphoonDefinitionPostProcessor>)postProcessor
{
    [self attachDefinitionPostProcessor:postProcessor];
}
#pragma clang diagnostic pop

- (void)inject:(id)instance
{
    @synchronized (self) {
        [self loadIfNeeded];
        TyphoonDefinition
                *definitionForInstance = [self definitionForType:[instance class] orNil:YES includeSubclasses:NO];
        if (definitionForInstance) {
            [self inject:instance withDefinition:definitionForInstance];
        }
    }
}

- (void)inject:(id)instance withSelector:(SEL)selector
{
    @synchronized (self) {
        [self loadIfNeeded];
        TyphoonDefinition *definition = [self definitionForKey:NSStringFromSelector(selector)];
        if (definition) {
            [self inject:instance withDefinition:definition];
        }
        else {
            [NSException raise:NSInvalidArgumentException format:@"Can't find definition for specified selector %@",
                                                                 NSStringFromSelector(selector)];
        }
    }
}


//-------------------------------------------------------------------------------------------
#pragma mark - Utility Methods
//-------------------------------------------------------------------------------------------

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"_registry=%@", _registry];
    [description appendString:@">"];
    return description;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)_load
{
    [self preparePostProcessors];
    [self applyPostProcessors];
    [self instantiateEagerSingletons];
}

- (NSArray *)orderedArray:(NSMutableArray *)array
{
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger firstObjectOrder = TyphoonOrderLowestPriority;
        NSInteger secondObjectOrder = TyphoonOrderLowestPriority;
        if ([obj1 conformsToProtocol:@protocol(TyphoonOrdered)]) {
            firstObjectOrder = [obj1 order];
        }
        if ([obj2 conformsToProtocol:@protocol(TyphoonOrdered)]) {
            secondObjectOrder = [obj2 order];
        }
        return [@(firstObjectOrder) compare:@(secondObjectOrder)];
    }];
}


- (void)preparePostProcessors
{
    _definitionPostProcessors = [[self orderedArray:_definitionPostProcessors] mutableCopy];
    _instancePostProcessors = [[self orderedArray:_instancePostProcessors] mutableCopy];
}

- (void)applyPostProcessors
{
    [self enumerateDefinitions:^(TyphoonDefinition *definition, NSUInteger index, TyphoonDefinition **definitionToReplace, BOOL *stop) {
        TyphoonDefinition *result = [self definitionAfterApplyingPostProcessorsToDefinition:definition];
        if (definitionToReplace && result != definition) {
            *definitionToReplace = result;
        }
    }];
}

- (TyphoonDefinition *)definitionAfterApplyingPostProcessorsToDefinition:(TyphoonDefinition *)definition
{
    TyphoonDefinition *result = definition;

    for (id<TyphoonDefinitionPostProcessor> postProcessor in _definitionPostProcessors) {
        TyphoonDefinition *currentReplacement = nil;
        [postProcessor postProcessDefinition:result replacement:&currentReplacement withFactory:self];
        if (currentReplacement) {
            result = currentReplacement;
        }
    }

    return result;
}

- (void)instantiateEagerSingletons
{
    [_registry enumerateObjectsUsingBlock:^(TyphoonDefinition *definition, NSUInteger idx, BOOL *stop) {
        [self instantiateIfEagerSingleton:definition];
    }];
}

- (void)instantiateIfEagerSingleton:(TyphoonDefinition *)definition
{
    if (definition.scope == TyphoonScopeSingleton) {
        [self newOrScopeCachedInstanceForDefinition:definition args:nil];
    }
}

- (NSString *)poolKeyForDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    if (args) {
        return [NSString stringWithFormat:@"%@-%ld", definition.key, (unsigned long)[args hash]];
    }
    else {
        return definition.key;
    }
}

- (id<TyphoonComponentsPool>)poolForDefinition:(TyphoonDefinition *)definition
{
    switch (definition.scope) {
        case TyphoonScopeSingleton:
        case TyphoonScopeLazySingleton:
            return _singletons;
        case TyphoonScopeWeakSingleton:
            return _weakSingletons;
        case TyphoonScopeObjectGraph:
            return _objectGraphSharedInstances;
        default:
        case TyphoonScopePrototype:
            return nil;
    }
}

- (void)inject:(id)instance withDefinition:(TyphoonDefinition *)definition
{
    @synchronized (self) {
        id<TyphoonComponentsPool> pool = [self poolForDefinition:definition];
        [pool setObject:instance forKey:definition.key];
        TyphoonStackElement *element = [TyphoonStackElement elementWithKey:definition.key args:nil];
        [element takeInstance:instance];
        [_stack push:element];
        [self doInjectionEventsOn:instance withDefinition:definition args:nil];
        [_stack pop];
        if ([_stack isEmpty]) {
            [_objectGraphSharedInstances removeAllObjects];
        }
    }
}

@end


@implementation TyphoonComponentFactory (TyphoonDefinitionRegisterer)

- (TyphoonDefinition *)definitionForKey:(NSString *)key
{
    for (TyphoonDefinition *definition in _registry) {
        if ([definition.key isEqualToString:key]) {
            return definition;
        }
    }
    return nil;
}

- (id)newOrScopeCachedInstanceForDefinition:(TyphoonDefinition *)definition args:(TyphoonRuntimeArguments *)args
{
    if (definition.abstract) {
        [NSException raise:NSInvalidArgumentException format:@"Attempt to instantiate abstract definition: %@",
                                                             definition];
    }

    @synchronized (self) {

        id<TyphoonComponentsPool> pool = [self poolForDefinition:definition];
        id instance = nil;

        NSString *poolKey = [self poolKeyForDefinition:definition args:args];
        instance = [pool objectForKey:poolKey];
        if (instance == nil) {
            instance = [self buildSharedInstanceForDefinition:definition args:args];
            if (instance) {
                [pool setObject:instance forKey:poolKey];
            }
        }

        if ([_stack isEmpty]) {
            [_objectGraphSharedInstances removeAllObjects];
        }

        return instance;
    }
}

- (void)addDefinitionToRegistry:(TyphoonDefinition *)definition
{
    [_registry addObject:definition];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)addInstancePostProcessor:(id<TyphoonInstancePostProcessor>)postProcessor
{
    [self attachInstancePostProcessor:postProcessor];
}
#pragma clang diagnostic pop

@end
