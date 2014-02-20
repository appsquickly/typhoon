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
#import "TyphoonComponentPostProcessor.h"
#import "TyphoonWeakComponentsPool.h"

typedef id(^TyphoonInstanceBuildBlock)(TyphoonDefinition *definition);

@interface TyphoonDefinition (TyphoonComponentFactory)

@property(nonatomic, strong) NSString *key;

@end

@implementation TyphoonComponentFactory

static TyphoonComponentFactory *defaultFactory;


/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (id)defaultFactory
{
    return defaultFactory;
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        _registry = [[NSMutableArray alloc] init];
        _singletons = (id <TyphoonComponentsPool>) [[NSMutableDictionary alloc] init];
        _weakSingletons = [TyphoonWeakComponentsPool new];
        _objectGraphSharedInstances = (id <TyphoonComponentsPool>) [[NSMutableDictionary alloc] init];
        _stack = [TyphoonCallStack stack];
        _factoryPostProcessors = [[NSMutableArray alloc] init];
        _componentPostProcessors = [[NSMutableArray alloc] init];
        [self attachPostProcessor:[[TyphoonParentReferenceHydratingPostProcessor alloc] init]];
        [self attachPostProcessor:[[TyphoonFactoryPropertyInjectionPostProcessor alloc] init]];

    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

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
            [_singletons removeAllObjects];
            [self setLoaded:NO];
        }
    }
}

- (void)registerDefinition:(TyphoonDefinition *)definition
{
    TyphoonDefinitionRegisterer *registerer = [[TyphoonDefinitionRegisterer alloc] initWithDefinition:definition componentFactory:self];
    [registerer register];

    if ([self isLoaded]) {
        [self _load];
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
    if (![self isLoaded]) {[self load];}
    return [self objectForDefinition:[self definitionForType:classOrProtocol]];
}

- (NSArray *)allComponentsForType:(id)classOrProtocol
{
    if (![self isLoaded]) {[self load];}
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSArray *definitions = [self allDefinitionsForType:classOrProtocol];
    for (TyphoonDefinition *definition in definitions) {
        [results addObject:[self objectForDefinition:definition]];
    }
    return [results copy];
}

- (id)componentForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }

    [self loadIfNeeded];

    TyphoonDefinition *definition = [self definitionForKey:key];
    if (!definition) {
        [NSException raise:NSInvalidArgumentException format:@"No component matching id '%@'.", key];
    }

    return [self objectForDefinition:definition];
}

- (void)loadIfNeeded
{
    if ([self notLoaded]) {
        [self load];
    }
}

- (BOOL)notLoaded
{
    return ![self isLoaded];
}

- (void)makeDefault
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultFactory = self;
    });
}

- (NSArray *)registry
{
    [self loadIfNeeded];

    return [_registry copy];
}

- (void)attachPostProcessor:(id <TyphoonComponentFactoryPostProcessor>)postProcessor
{
    LogTrace(@"Attaching post processor: %@", postProcessor);
    [_factoryPostProcessors addObject:postProcessor];
    if ([self isLoaded]) {
        LogDebug(@"Definitions registered, refreshing all singletons.");
        [self unload];
    }
}

- (void)injectProperties:(id)instance
{
    Class class = [instance class];
    for (TyphoonDefinition *definition in _registry) {
        if (definition.type == class) {
            [self doPropertyInjectionEventsOn:instance withDefinition:definition];
        }
    }
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"_registry=%@", _registry];
    [description appendString:@">"];
    return description;
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

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
    _factoryPostProcessors = [[self orderedArray:_factoryPostProcessors] mutableCopy];
    _componentPostProcessors = [[self orderedArray:_componentPostProcessors] mutableCopy];
}

- (void)applyPostProcessors
{
    [_factoryPostProcessors enumerateObjectsUsingBlock:^(id <TyphoonComponentFactoryPostProcessor> postProcessor, NSUInteger idx, BOOL *stop) {
        [postProcessor postProcessComponentFactory:self];
    }];
}

- (void)instantiateEagerSingletons
{
    [_registry enumerateObjectsUsingBlock:^(id definition, NSUInteger idx, BOOL *stop) {
        if (([definition scope] == TyphoonScopeSingleton) && ![definition isLazy]) {
            [self sharedInstanceForDefinition:definition fromPool:_singletons];
        }
    }];
}

- (id)sharedInstanceForDefinition:(TyphoonDefinition *)definition fromPool:(id <TyphoonComponentsPool>)pool
{
    @synchronized (self) {
        id instance = [pool objectForKey:definition.key];
        if (instance == nil) {
            instance = [self buildSharedInstanceForDefinition:definition];
            [pool setObject:instance forKey:definition.key];
        }
        return instance;
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

- (id)objectForDefinition:(TyphoonDefinition *)definition
{
    if (definition.abstract) {
        [NSException raise:NSInvalidArgumentException format:@"Attempt to instantiate abstract definition: %@", definition];
    }

    id instance = nil;
    switch (definition.scope) {
        case TyphoonScopeSingleton:
            instance = [self sharedInstanceForDefinition:definition fromPool:_singletons];
            break;
        case TyphoonScopeWeakSingleton:
            instance = [self sharedInstanceForDefinition:definition fromPool:_weakSingletons];
            break;
        case TyphoonScopeObjectGraph:
            instance = [self sharedInstanceForDefinition:definition fromPool:_objectGraphSharedInstances];
            break;
        default:
        case TyphoonScopePrototype:
            instance = [self buildInstanceWithDefinition:definition];
            break;
    }

    if ([_stack isEmpty]) {
        [_objectGraphSharedInstances removeAllObjects];
    }

    return instance;
}

- (void)addDefinitionToRegistry:(TyphoonDefinition *)definition
{
    [_registry addObject:definition];
}

- (void)addComponentPostProcessor:(id <TyphoonComponentPostProcessor>)postProcessor
{
    [_componentPostProcessors addObject:postProcessor];
}

@end