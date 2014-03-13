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



#import "TyphoonInitializer.h"
#import "TyphoonDefinition.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonDefinition+Infrastructure.h"

#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonPropertyInjection.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonInjections.h"

@interface TyphoonDefinition () <TyphoonObjectWithCustomInjection>

@end

@implementation TyphoonDefinition

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonDefinition *)withClass:(Class)clazz
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:nil];
}

+ (TyphoonDefinition *)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:nil];
}

+ (TyphoonDefinition *)withClass:(Class)clazz properties:(TyphoonDefinitionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:nil properties:properties];
}

+ (TyphoonDefinition *)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization
    properties:(TyphoonDefinitionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:properties];
}

+ (TyphoonDefinition *)withClass:(Class)clazz key:(NSString *)key initialization:(TyphoonInitializerBlock)initialization
    properties:(TyphoonDefinitionBlock)properties
{

    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:clazz key:key];
    if (initialization) {
        TyphoonInitializer *componentInitializer = [[TyphoonInitializer alloc] init];
        definition.initializer = componentInitializer;
        __weak TyphoonInitializer *weakInitializer = componentInitializer;
        initialization(weakInitializer);
    }
    if (properties) {
        __weak TyphoonDefinition *weakDefinition = definition;
        properties(weakDefinition);
    }
    if (definition.lazy && definition.scope != TyphoonScopeSingleton) {
        [NSException raise:NSInvalidArgumentException
            format:@"The lazy attribute is only applicable to singleton scoped definitions, but is set for definition: %@ ", definition];
    }
    
    BOOL hasRuntimeInjections = [[definition.initializer parametersInjectedByRuntimeArgument] count] > 0 || [[definition propertiesInjectedByRuntimeArgument] count] > 0;
    if (hasRuntimeInjections && definition.scope != TyphoonScopePrototype) {
        [NSException raise:NSInvalidArgumentException
                    format:@"The runtime arguments injections are only applicable to prototype scoped definitions, but is set for definition: %@ ", definition];

    }

    return definition;
}

+ (TyphoonDefinition *)withClass:(Class)clazz key:(NSString *)key initialization:(TyphoonInitializerBlock)initialization
{
    return [TyphoonDefinition withClass:clazz key:key initialization:initialization properties:nil];
}

+ (TyphoonDefinition *)withClass:(Class)clazz key:(NSString *)key properties:(TyphoonDefinitionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:key initialization:nil properties:properties];
}

+ (TyphoonDefinition *)withClass:(Class)clazz factory:(TyphoonDefinition *)_definition selector:(SEL)selector
{
    return [TyphoonDefinition withClass:clazz initialization:^(TyphoonInitializer *initializer) {
        [initializer setSelector:selector];
    } properties:^(TyphoonDefinition *definition) {
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

- (void)setInitializer:(TyphoonInitializer *)initializer
{
    _initializer = initializer;
    [_initializer setDefinition:self];
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

- (TyphoonInitializer *)initializer
{
    if (!_initializer) {
        TyphoonInitializer *parentInitializer = _parent.initializer;
        if (parentInitializer) {
            return parentInitializer;
        }
        else {
            [self setInitializer:[[TyphoonInitializer alloc] init]];
            [self.initializer setValue:@(YES) forKey:@"generated"];
        }
    }
    return _initializer;
}

- (NSSet *)injectedProperties
{
    NSMutableSet *parentProperties = [_parent injectedProperties] ? [[_parent injectedProperties] mutableCopy] : [NSMutableSet set];

    NSMutableArray *overriddenProperties = [NSMutableArray array];
    [parentProperties enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([_injectedProperties containsObject:obj]) {
            [overriddenProperties addObject:obj];
        }
    }];

    for (id<TyphoonPropertyInjection> overriddenProperty in overriddenProperties) {
        [parentProperties removeObject:overriddenProperty];
    }

    return [[parentProperties setByAddingObjectsFromSet:_injectedProperties] copy];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"Definition: class='%@', key='%@'", NSStringFromClass(_type), _key];
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonDefinition *copy = [[TyphoonDefinition alloc] initWithClass:_type key:[_key copy] factoryComponent:_factory.key];
    [copy setInitializer:[self.initializer copy]];
    for (id<TyphoonPropertyInjection> property in _injectedProperties) {
        [copy addInjectedProperty:[property copyWithZone:NSDefaultMallocZone()]];
    }
    return copy;
}


@end
