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



#import "TyphoonMethod.h"
#import "TyphoonDefinition.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonDefinition+Infrastructure.h"

#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonPropertyInjection.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonInjections.h"

static NSString *TyphoonScopeToString(TyphoonScope scope) {
    switch (scope) {
        case TyphoonScopeObjectGraph:
            return @"ObjectGraph";
        case TyphoonScopePrototype:
            return @"Prototype";
        case TyphoonScopeSingleton:
            return @"Singleton";
        case TyphoonScopeWeakSingleton:
            return @"WeakSingleton";
        default:
            return @"Unknown";
    }
}


@interface TyphoonDefinition () <TyphoonObjectWithCustomInjection>

@end

@implementation TyphoonDefinition
{
    BOOL _isScopeSetByUser;
}

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (id)withClass:(Class)clazz
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:nil];
}

+ (id)withClass:(Class)clazz configuration:(TyphoonDefinitionBlock)injections
{
    return [TyphoonDefinition withClass:clazz key:nil injections:injections];
}

+ (TyphoonDefinition *)withClass:(Class)clazz key:(NSString *)key injections:(TyphoonDefinitionBlock)properties
{
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:clazz key:key];

    if (properties) {
        __weak TyphoonDefinition *weakDefinition = definition;
        properties(weakDefinition);
    }

    [definition validateScope];

    return definition;
}

+ (id)withFactory:(id)factory selector:(SEL)selector
{
    return [TyphoonDefinition withFactory:factory selector:selector parameters:nil];
}

+ (id)withFactory:(id)factory selector:(SEL)selector parameters:(void (^)(TyphoonMethod *method))parametersBlock
{
    return [TyphoonDefinition withClass:[NSObject class] configuration:^(TyphoonDefinition *definition) {
        [definition setFactory:factory];
        [definition setScope:TyphoonScopePrototype];
        [definition useInitializer:selector parameters:parametersBlock];
    }];
}

/* ====================================================================================================================================== */
#pragma mark - TyphoonObjectWithCustomInjection

- (id)typhoonCustomObjectInjection
{
    return [[TyphoonInjectionByReference alloc] initWithReference:self.key args:self.currentRuntimeArguments];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)injectProperty:(SEL)selector
{
    [self injectProperty:selector with:[[TyphoonInjectionByType alloc] init]];
}

- (void)injectProperty:(SEL)selector with:(id)injection
{
    injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
    [injection setPropertyName:NSStringFromSelector(selector)];
    [_injectedProperties addObject:injection];
}

- (void)injectMethod:(SEL)selector parameters:(void(^)(TyphoonMethod *method))parametersBlock
{
    TyphoonMethod *method = [[TyphoonMethod alloc] initWithSelector:selector];
    if (parametersBlock) {
        parametersBlock(method);
    }
    [method checkParametersCount];
    [_injectedMethods addObject:method];
}

- (void)useInitializer:(SEL)selector parameters:(void(^)(TyphoonMethod *initializer))parametersBlock
{
    TyphoonMethod *initializer = [[TyphoonMethod alloc] initWithSelector:selector];
    if (parametersBlock) {
        parametersBlock(initializer);
    }
    [initializer checkParametersCount];
    self.initializer = initializer;
}

- (void)useInitializer:(SEL)selector
{
    [self useInitializer:selector parameters:nil];
}

- (void)setInitializer:(TyphoonMethod *)initializer
{
    _initializer = initializer;
}

/* ====================================================================================================================================== */
#pragma mark - Making injections

- (id)property:(SEL)factorySelector
{
    return [self keyPath:NSStringFromSelector(factorySelector)];
}

- (id)keyPath:(NSString *)keyPath
{
    return [[TyphoonInjectionByFactoryReference alloc] initWithReference:self.key args:self.currentRuntimeArguments keyPath:keyPath];
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (TyphoonMethod *)initializer
{
    if (!_initializer) {
        TyphoonMethod *parentInitializer = _parent.initializer;
        if (parentInitializer) {
            return parentInitializer;
        }
        else {
            [self setInitializer:[[TyphoonMethod alloc] initWithSelector:@selector(init)]];
            self.initializerGenerated = YES;
        }
    }
    return _initializer;
}

- (BOOL)isInitializerGenerated
{
    [self initializer]; //call getter to generate initializer if needed
    return _initializerGenerated;
}

- (TyphoonScope)scope
{
    if (_parent && !_isScopeSetByUser) {
        return _parent.scope;
    }
    return _scope;
}

- (void)setScope:(TyphoonScope)scope
{
    _scope = scope;
    _isScopeSetByUser = YES;
    [self validateScope];
}

- (void)setFactory:(id)factory
{
    _factory = factory;
    if (![_factory isKindOfClass:[TyphoonDefinition class]]) {
        [NSException raise:NSInvalidArgumentException format:@"Only TyphoonDefinition object can be set as factory. But in method '%@' object of class %@ set as factory", self.key, [factory class]];
    }
}

- (void)setParent:(id)parent
{
    _parent = parent;
    if (![_parent isKindOfClass:[TyphoonDefinition class]]) {
        [NSException raise:NSInvalidArgumentException format:@"Only TyphoonDefinition object can be set as parent. But in method '%@' object of class %@ set as parent", self.key, [parent class]];
    }
}


/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"Definition: class='%@', key='%@', scope='%@'", NSStringFromClass(_type), _key,
                                      TyphoonScopeToString(_scope)];
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonDefinition *copy = [[TyphoonDefinition alloc] initWithClass:_type key:[_key copy] factoryComponent:_factory.key];
    [copy setInitializer:[self.initializer copy]];
    for (id <TyphoonPropertyInjection> property in _injectedProperties) {
        [copy addInjectedProperty:[property copyWithZone:NSDefaultMallocZone()]];
    }
    return copy;
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)validateScope
{
    if (self.lazy && self.scope != TyphoonScopeSingleton) {
        [NSException raise:NSInvalidArgumentException
            format:@"The lazy attribute is only applicable to singleton scoped definitions, but is set for definition: %@ ", self];
    }

    if ((self.scope != TyphoonScopePrototype && self.scope != TyphoonScopeObjectGraph) && [self hasRuntimeArgumentInjections]) {
        [NSException raise:NSInvalidArgumentException
            format:@"The runtime arguments injections are only applicable to prototype and object-graph scoped definitions, but is set for definition: %@ ",
                   self];
    }
}


@end
