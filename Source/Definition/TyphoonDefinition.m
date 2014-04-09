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

+ (TyphoonDefinition *)withClass:(Class)clazz
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:nil];
}

+ (TyphoonDefinition *)withClass:(Class)clazz injections:(TyphoonDefinitionBlock)injections
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

+ (TyphoonDefinition *)withClass:(Class)clazz factory:(TyphoonDefinition *)_definition selector:(SEL)selector
{
    return [TyphoonDefinition withClass:clazz injections:^(TyphoonDefinition *definition) {
        [definition injectInitializer:selector parameters:nil];
        [definition setFactory:_definition];
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
    [_injectedMethods addObject:method];
}

- (void)injectInitializer:(SEL)selector parameters:(void(^)(TyphoonMethod *initializer))parametersBlock
{
    TyphoonMethod *initializer = [[TyphoonMethod alloc] initWithSelector:selector];
    if (parametersBlock) {
        parametersBlock(initializer);
    }
    self.initializer = initializer;
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

- (BOOL)hasRuntimeArgumentInjections
{
    return [[self.initializer parametersInjectedByRuntimeArgument] count] > 0 || [[self propertiesInjectedByRuntimeArgument] count] > 0;
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
