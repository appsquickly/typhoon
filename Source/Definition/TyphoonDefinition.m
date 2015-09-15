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
#import "TyphoonFactoryDefinition.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonInjectionDefinition.h"

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


@interface TyphoonDefinition ()<TyphoonObjectWithCustomInjection>
@property (nonatomic, strong) TyphoonMethod *initializer;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) TyphoonRuntimeArguments *currentRuntimeArguments;
@property (nonatomic, getter = isInitializerGenerated) BOOL initializerGenerated;
@end

@implementation TyphoonDefinition
{
    BOOL _isScopeSetByUser;
}

@synthesize key = _key;
@synthesize initializerGenerated = _initializerGenerated;
@synthesize currentRuntimeArguments = _currentRuntimeArguments;

//-------------------------------------------------------------------------------------------
#pragma mark: - Initialization
//-------------------------------------------------------------------------------------------

- (id)initWithClass:(Class)clazz key:(NSString *)key
{
    self = [super init];
    if (self) {
        _type = clazz;
        _injectedProperties = [[NSMutableSet alloc] init];
        _injectedMethods = [[NSMutableOrderedSet alloc] init];
        _key = [key copy];
        _scope = TyphoonScopeObjectGraph;
        self.autoInjectionVisibility = TyphoonAutoInjectVisibilityDefault;
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (id)init
{
    return [self initWithClass:nil key:nil];
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
    [injection setPropertyName:NSStringFromSelector(selector)];
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

- (void)performAfterInjections:(SEL)sel parameters:(void (^)(TyphoonMethod *param))parameterBlock
{
    _afterInjections = [[TyphoonMethod alloc] initWithSelector:sel];
    if (parameterBlock) {
        parameterBlock(_afterInjections);
    }
#if DEBUG
    [_afterInjections checkParametersCount];
#endif
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
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

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

- (void)setParent:(id)parent
{
    _parent = parent;
    if (![_parent isKindOfClass:[TyphoonDefinition class]]) {
        [NSException raise:NSInvalidArgumentException
            format:@"Only TyphoonDefinition object can be set as parent. But in method '%@' object of class %@ set as parent",
                   self.key, [parent class]];
    }
}


//-------------------------------------------------------------------------------------------
#pragma mark - Utility Methods
//-------------------------------------------------------------------------------------------

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: class='%@', key='%@', scope='%@'", NSStringFromClass([self class]),
                                      NSStringFromClass(_type), _key, TyphoonScopeToString(_scope)];
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonDefinition *copy = [[TyphoonDefinition alloc] initWithClass:_type key:[_key copy]];
    copy->_processed = _processed;
    copy->_initializer = [_initializer copy];
    copy->_beforeInjections = [_beforeInjections copy];
    copy->_injectedProperties = [_injectedProperties mutableCopy];
    copy->_injectedMethods = [_injectedMethods mutableCopy];
    copy->_afterInjections = [_afterInjections copy];
    copy->_scope = _scope;
    copy->_parent = _parent;
    copy->_isScopeSetByUser = _isScopeSetByUser;
    copy->_autoInjectionVisibility = _autoInjectionVisibility;
    copy->_abstract = _abstract;
    copy->_initializerGenerated = _initializerGenerated;
    copy->_currentRuntimeArguments = [_currentRuntimeArguments copy];
    return copy;
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


//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)validateRequiredParametersAreSet
{
    if (_type == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
    
    BOOL hasAppropriateSuper = [_type isSubclassOfClass:[NSObject class]] || [_type isSubclassOfClass:[NSProxy class]];
    if (!hasAppropriateSuper) {
        [NSException raise:NSInvalidArgumentException format:@"Subclass of NSProxy or NSObject is required."];
    }
}

@end



