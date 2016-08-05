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


#import "TyphoonDefinition.h"
#import "TyphoonDefinition+Internal.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonMethod.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonPropertyInjection.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonInjections.h"
#import "TyphoonFactoryDefinition.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonInjectionDefinition.h"

#import "OCLogTemplate.h"


static NSString *TyphoonScopeToString(TyphoonScope scope)
{
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
    TyphoonDefinition *_parent;
    NSMutableSet *_injectedProperties;
    NSMutableOrderedSet *_injectedMethods;
}

//-------------------------------------------------------------------------------------------
#pragma mark: - Initialization
//-------------------------------------------------------------------------------------------

- (instancetype)init
{
    return [self initWithClass:Nil key:nil];
}

- (instancetype)initWithClass:(Class)clazz key:(NSString *)key
{
    if (clazz == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
    
    self = [super init];
    if (self) {
        _type = clazz;
        _key = key;
        _scope = TyphoonScopeObjectGraph;
        _autoInjectionVisibility = TyphoonAutoInjectVisibilityDefault;
        
        _injectedProperties = [[NSMutableSet alloc] init];
        _injectedMethods = [[NSMutableOrderedSet alloc] init];
        
        [self validateRequiredParametersAreSet];
    }
    return self;
}

+ (instancetype)withClass:(Class)clazz key:(NSString *)key
{
    return [[self alloc] initWithClass:clazz key:key];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Scope
//-------------------------------------------------------------------------------------------

@synthesize scope = _scope;

- (TyphoonScope)scope
{
    if (_parent && !_scopeSetByUser) {
        return _parent.scope;
    }
    else {
        return _scope;
    }
}

- (void)setScope:(TyphoonScope)scope
{
    _scope = scope;
    _scopeSetByUser = YES;
    
    [self validateScope];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Namespacing
//-------------------------------------------------------------------------------------------

- (void)applyGlobalNamespace
{
    _space = [TyphoonDefinitionNamespace globalNamespace];
}

- (void)applyConcreteNamespace:(NSString *)key
{
    _space = [TyphoonDefinitionNamespace namespaceWithKey:key];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Injections
//-------------------------------------------------------------------------------------------

@synthesize initializer = _initializer;
@synthesize beforeInjections = _beforeInjections;
@synthesize afterInjections = _afterInjections;

- (TyphoonMethod *)initializer
{
    if (!_initializer) {
        TyphoonMethod *parentInitializer = _parent.initializer;
        if (parentInitializer) {
            return parentInitializer;
        }
        else {
            _initializer = [[TyphoonMethod alloc] initWithSelector:@selector(init)];
            _initializerGenerated = YES;
        }
    }
    return _initializer;
}

- (BOOL)isInitializerGenerated
{
    [self initializer]; // call getter to generate initializer if needed
    return _initializerGenerated;
}

- (TyphoonMethod *)beforeInjections
{
    if (!_parent || _beforeInjections) {
        return _beforeInjections;
    }
    else {
        return [_parent beforeInjections];
    }
}

- (TyphoonMethod *)afterInjections
{
    if (!_parent || _afterInjections) {
        return _afterInjections;
    }
    else {
        return [_parent afterInjections];
    }
}

- (NSSet *)injectedProperties
{
    if (!_parent) {
        return [_injectedProperties mutableCopy];
    }
    
    NSMutableSet *properties = (NSMutableSet *)[_parent injectedProperties];
    
    NSMutableSet *overriddenProperties = [NSMutableSet set];
    
    for (id<TyphoonPropertyInjection> parentProperty in properties) {
        for (id <TyphoonPropertyInjection> childProperty in _injectedProperties) {
            if ([[childProperty propertyName] isEqualToString:[parentProperty propertyName]]) {
                [overriddenProperties addObject:parentProperty];
            }
        }
    }
    
    [properties minusSet:overriddenProperties];
    [properties unionSet:_injectedProperties];
    
    return properties;
}

- (NSOrderedSet *)injectedMethods
{
    if (!_parent) {
        return [_injectedMethods mutableCopy];
    }
    
    NSMutableOrderedSet *methods = (NSMutableOrderedSet *)[_parent injectedMethods];
    
    NSMutableSet *overriddenMethods = [NSMutableSet set];
    for (TyphoonMethod *parentMethod in methods) {
        for (TyphoonMethod *childMethod in _injectedMethods) {
            if (parentMethod.selector == childMethod.selector) {
                [overriddenMethods addObject:parentMethod];
            }
        }
    }
    
    [methods minusSet:overriddenMethods];
    [methods unionOrderedSet:_injectedMethods];
    
    return methods;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Parent
//-------------------------------------------------------------------------------------------

- (void)setParent:(id)parent
{
    _parent = parent;
    [self validateParent];
}

//-------------------------------------------------------------------------------------------
#pragma mark: - Class Methods
//-------------------------------------------------------------------------------------------

- (id)factory
{
    return nil;
}

+ (id)withClass:(Class)clazz
{
    return [[self alloc] initWithClass:clazz key:nil];
}

+ (id)withClass:(Class)clazz configuration:(TyphoonDefinitionBlock)injections
{
    return [self withClass:clazz key:nil injections:injections];
}

+ (id)withClass:(Class)clazz key:(NSString *)key injections:(TyphoonDefinitionBlock)configuration
{
    TyphoonDefinition *definition = [[self alloc] initWithClass:clazz key:key];

    if (configuration) {
        configuration(definition);
    }

    [definition validateScope];

    return definition;
}

+ (id)withParent:(id)parent class:(Class)clazz
{
    return [self withParent:parent class:clazz configuration:nil];
}


+ (id)withParent:(id)parent class:(Class)clazz configuration:(TyphoonDefinitionBlock)injections
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:clazz configuration:injections];
    definition.parent = parent;
    return definition;
}


+ (id)withFactory:(id)factory selector:(SEL)selector
{
    return [self withFactory:factory selector:selector parameters:nil];
}

+ (id)withFactory:(id)factory selector:(SEL)selector parameters:(void (^)(TyphoonMethod *method))params
{
    return [self withFactory:factory selector:selector parameters:params configuration:nil];
}

+ (id)withFactory:(id)factory selector:(SEL)selector parameters:(void (^)(TyphoonMethod *))parametersBlock
    configuration:(void (^)(TyphoonFactoryDefinition *))configuration
{
    TyphoonFactoryDefinition *definition = [[TyphoonFactoryDefinition alloc]
        initWithFactory:factory selector:selector parameters:parametersBlock];

    if (configuration) {
        configuration(definition);
    }

    return definition;
}

//-------------------------------------------------------------------------------------------
#pragma mark - TyphoonObjectWithCustomInjection
//-------------------------------------------------------------------------------------------

- (id)typhoonCustomObjectInjection
{
    return [[TyphoonInjectionByReference alloc] initWithReference:self.key args:self.currentRuntimeArguments];
}

//-------------------------------------------------------------------------------------------
#pragma mark: - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)injectProperty:(SEL)selector
{
    [self injectProperty:selector with:[[TyphoonInjectionByType alloc] init]];
}

- (void)injectProperty:(SEL)selector with:(id)injection
{
    injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
    NSString *propertyName = NSStringFromSelector(selector);
    [injection setPropertyName:propertyName];
    
    if ([_injectedProperties containsObject:injection]) {
        LogInfo(@"*** Warning *** The definition (key: %@, namespace: %@) contains duplicate injections for property '%@'. Is this intentional?", self.key, self.space.key, propertyName);
    }
    
    [_injectedProperties addObject:injection];
}

- (void)injectMethod:(SEL)selector parameters:(void (^)(TyphoonMethod *method))parametersBlock
{
    TyphoonMethod *method = [[TyphoonMethod alloc] initWithSelector:selector];
    if (parametersBlock) {
        parametersBlock(method);
    }
#if DEBUG
    [method checkParametersCount];
#endif
    [_injectedMethods addObject:method];
}

- (void)useInitializer:(SEL)selector parameters:(void (^)(TyphoonMethod *initializer))parametersBlock
{
    TyphoonMethod *initializer = [[TyphoonMethod alloc] initWithSelector:selector];
    if (parametersBlock) {
        parametersBlock(initializer);
    }
#if DEBUG
    [initializer checkParametersCount];
#endif
    _initializer = initializer;
}

- (void)useInitializer:(SEL)selector
{
    [self useInitializer:selector parameters:nil];
}

- (void)performBeforeInjections:(SEL)sel
{
    [self performBeforeInjections:sel parameters:nil];
}

- (void)performBeforeInjections:(SEL)sel parameters:(void (^)(TyphoonMethod *params))parametersBlock
{
    _beforeInjections = [[TyphoonMethod alloc] initWithSelector:sel];
    if (parametersBlock) {
        parametersBlock(_beforeInjections);
    }
#if DEBUG
    [_beforeInjections checkParametersCount];
#endif
}

- (void)performAfterInjections:(SEL)sel
{
    [self performAfterInjections:sel parameters:nil];
}

- (void)performAfterInjections:(SEL)sel parameters:(void (^)(TyphoonMethod *params))parameterBlock
{
    _afterInjections = [[TyphoonMethod alloc] initWithSelector:sel];
    if (parameterBlock) {
        parameterBlock(_afterInjections);
    }
#if DEBUG
    [_afterInjections checkParametersCount];
#endif
}

- (void)performAfterAllInjections:(SEL)sel
{
    _afterAllInjections = sel;
}

//-------------------------------------------------------------------------------------------
#pragma mark: - TyphoonDefinition+Infrastructure methods
//-------------------------------------------------------------------------------------------

- (BOOL)hasRuntimeArgumentInjections
{
    __block BOOL hasInjections = NO;
    [self enumerateInjectionsOfKind:[TyphoonInjectionByRuntimeArgument class] options:TyphoonInjectionsEnumerationOptionAll
                         usingBlock:^(id injection, id *injectionToReplace, BOOL *stop) {
        hasInjections = YES;
        *stop = YES;
    }];
    return hasInjections;
}

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByClass) {
        BOOL isSameClass = self.type == clazz;
        BOOL isSubclass = includeSubclasses && [self.type isSubclassOfClass:clazz];
        result = isSameClass || isSubclass;
    }
    return result;
}

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByProtocol) {
        result = [self.type conformsToProtocol:aProtocol];
    }
    return result;
}

- (void)addInjectedProperty:(id <TyphoonPropertyInjection>)property
{
    [_injectedProperties addObject:property];
}

- (void)addInjectedPropertyIfNotExists:(id <TyphoonPropertyInjection>)property
{
    for (id<TyphoonPropertyInjection> injection in self.injectedProperties) {
        if ([[injection propertyName] isEqualToString:[property propertyName]]) {
            return;
        }
    }
    
    [_injectedProperties addObject:property];
}

- (void)replacePropertyInjection:(id<TyphoonPropertyInjection>)injection with:(id<TyphoonPropertyInjection>)injectionToReplace
{
    if ([_injectedProperties containsObject:injection]) {
        [injectionToReplace setPropertyName:[injection propertyName]];
        [_injectedProperties removeObject:injection];
        [_injectedProperties addObject:injectionToReplace];
    } else if ([_parent.injectedProperties containsObject:injection]) {
//        [self addInjectedProperty:injectionToReplace];
        [_parent replacePropertyInjection:injection with:injectionToReplace];
    }
}

- (void)enumerateInjectionsOfKind:(Class)injectionClass options:(TyphoonInjectionsEnumerationOption)options
                       usingBlock:(TyphoonInjectionsEnumerationBlock)block
{
    if (options & TyphoonInjectionsEnumerationOptionMethods) {
        [self enumerateInjectionsOfKind:injectionClass onCollection:[_initializer injectedParameters] withBlock:block replaceBlock:^(id injection, id injectionToReplace) {
            [self->_initializer replaceInjection:injection with:injectionToReplace];
        }];

        for (TyphoonMethod *method in self.injectedMethods) {
            [self enumerateInjectionsOfKind:injectionClass onCollection:[method injectedParameters] withBlock:block replaceBlock:^(id injection, id injectionToReplace) {
                [method replaceInjection:injection with:injectionToReplace];
            }];
        }
        
        [self enumerateInjectionsOfKind:injectionClass onCollection:[_beforeInjections injectedParameters] withBlock:block replaceBlock:^(id injection, id injectionToReplace) {
            [self->_beforeInjections replaceInjection:injection with:injectionToReplace];
        }];
        
        [self enumerateInjectionsOfKind:injectionClass onCollection:[_afterInjections injectedParameters] withBlock:block replaceBlock:^(id injection, id injectionToReplace) {
            [self->_afterInjections replaceInjection:injection with:injectionToReplace];
        }];
    }

    if (options & TyphoonInjectionsEnumerationOptionProperties) {
        [self enumerateInjectionsOfKind:injectionClass onCollection:self.injectedProperties withBlock:block
                           replaceBlock:^(id injection, id injectionToReplace) {
            [self replacePropertyInjection:injection with:injectionToReplace];
        }];
    }
}

- (void)enumerateInjectionsOfKind:(Class)injectionClass onCollection:(id<NSFastEnumeration>)collection
                        withBlock:(TyphoonInjectionsEnumerationBlock)block
                     replaceBlock:(void(^)(id injection, id injectionToReplace))replaceBlock
{
    for (id<TyphoonInjection> injection in collection) {
        if ([injection isKindOfClass:injectionClass]) {
            id injectionToReplace = nil;
            BOOL stop = NO;
            
            block(injection, &injectionToReplace, &stop);
            
            if (injectionToReplace) {
                replaceBlock(injection, injectionToReplace);
            }
            
            if (stop) {
                break;
            }
        }
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Making injections
//-------------------------------------------------------------------------------------------

- (id)property:(SEL)factorySelector
{
    return [self keyPath:NSStringFromSelector(factorySelector)];
}

- (id)keyPath:(NSString *)keyPath
{
    return [[TyphoonInjectionByFactoryReference alloc]
        initWithReference:self.key args:self.currentRuntimeArguments keyPath:keyPath];
}

+ (id)with:(id)injection
{
    return [[TyphoonInjectionDefinition alloc] initWithInjection:TyphoonMakeInjectionFromObjectIfNeeded(injection)];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Utility Methods
//-------------------------------------------------------------------------------------------

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonDefinition *copy = [[[self class] allocWithZone:zone] initWithClass:_type key:[_key copy]];
    copy->_scope = _scope;
    copy->_scopeSetByUser = _scopeSetByUser;
    copy->_autoInjectionVisibility = _autoInjectionVisibility;
    copy->_space = _space;
    copy->_processed = _processed;
    copy->_currentRuntimeArguments = [_currentRuntimeArguments copy];
    copy->_initializer = [_initializer copy];
    copy->_initializerGenerated = _initializerGenerated;
    copy->_beforeInjections = [_beforeInjections copy];
    copy->_injectedProperties = [_injectedProperties mutableCopy];
    copy->_injectedMethods = [_injectedMethods mutableCopy];
    copy->_afterInjections = [_afterInjections copy];
    copy->_parent = _parent;
    copy->_abstract = _abstract;
    copy->_assembly = _assembly;
    copy->_assemblySelector = _assemblySelector;
    return copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: class='%@', key='%@', scope='%@'", NSStringFromClass([self class]),
            NSStringFromClass(_type), _key, TyphoonScopeToString(_scope)];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)validateScope
{
    if (self.scope == TyphoonScopeSingleton && [self hasRuntimeArgumentInjections]) {
        [NSException raise:NSInvalidArgumentException
            format:@"The runtime arguments injections are not applicable to singleton scoped definitions, because we don't know initial arguments to instantiate eager singletons. But it set for definition: %@ ",
                   self];
    }
}

- (void)validateParent
{
    if (![_parent isKindOfClass:[TyphoonDefinition class]]) {
        [NSException raise:NSInvalidArgumentException
            format:@"Only TyphoonDefinition object can be set as parent. But in method '%@' object of class %@ set as parent",
                   self.key, [_parent class]];
    }
}

- (void)validateRequiredParametersAreSet
{
    BOOL hasAppropriateSuper = [self.type isSubclassOfClass:[NSObject class]] || [self.type isSubclassOfClass:[NSProxy class]];
    if (!hasAppropriateSuper) {
        [NSException raise:NSInvalidArgumentException format:@"Subclass of NSProxy or NSObject is required."];
    }
}

@end
