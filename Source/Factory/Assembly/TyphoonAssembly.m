////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <objc/runtime.h>
#import "TyphoonAssembly.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssemblyDefinitionBuilder.h"
#import "TyphoonCollaboratingAssemblyPropertyEnumerator.h"
#import "TyphoonCollaboratingAssemblyProxy.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByComponentFactory.h"
#import "TyphoonDefinition+Infrastructure.h"

static NSMutableSet *reservedSelectorsAsStrings;

@interface TyphoonAssembly ()<TyphoonObjectWithCustomInjection>

@property (readwrite) NSSet *definitionSelectors;

@property (readonly) TyphoonAssemblyAdviser *adviser;

@end

@implementation TyphoonAssembly
{
    TyphoonAssemblyDefinitionBuilder *_definitionBuilder;
    TyphoonComponentFactory *_factory;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//-------------------------------------------------------------------------------------------

+ (TyphoonAssembly *)assembly
{
    return [[self alloc] init];
}

+ (instancetype)defaultAssembly
{
    return (TyphoonAssembly *)[TyphoonComponentFactory defaultFactory];
}

+ (void)load
{
    [self reserveSelectors];
}

+ (void)reserveSelectors
{
    reservedSelectorsAsStrings = [[NSMutableSet alloc] init];

    [self markSelectorReserved:@selector(init)];
    [self markSelectorReserved:@selector(definitions)];
    [self markSelectorReserved:@selector(prepareForUse)];
    [self markSelectorReservedFromString:@".cxx_destruct"];
    [self markSelectorReserved:@selector(defaultAssembly)];
    [self markSelectorReserved:@selector(resolveCollaboratingAssemblies)];
    [self markSelectorReserved:@selector(componentForType:)];
    [self markSelectorReserved:@selector(allComponentsForType:)];
    [self markSelectorReserved:@selector(componentForKey:)];
    [self markSelectorReserved:@selector(componentForKey:args:)];

}

+ (void)markSelectorReserved:(SEL)selector
{
    [self markSelectorReservedFromString:NSStringFromSelector(selector)];
}

+ (void)markSelectorReservedFromString:(NSString *)stringFromSelector
{
    [reservedSelectorsAsStrings addObject:stringFromSelector];
}

+ (BOOL)selectorIsReserved:(SEL)selector
{
    NSString *selectorString = NSStringFromSelector(selector);
    return [reservedSelectorsAsStrings containsObject:selectorString];
}


#pragma mark - Forwarding definition methods

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (_factory) {
        [_factory forwardInvocation:anInvocation];
    }
    else {
        TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromInvocation:anInvocation];
        NSString *key = NSStringFromSelector(anInvocation.selector);
        TyphoonDefinition *definition = [_definitionBuilder builtDefinitionForKey:key args:args];

        [anInvocation retainArguments];
        [anInvocation setReturnValue:&definition];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        _definitionBuilder = [[TyphoonAssemblyDefinitionBuilder alloc] initWithAssembly:self];
        _adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:self];
        [self resolveCollaboratingAssemblies];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - <TyphoonObjectWithCustomInjection>
//-------------------------------------------------------------------------------------------

- (id<TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return [[TyphoonInjectionByComponentFactory alloc] init];
}

//-------------------------------------------------------------------------------------------
#pragma mark - <TyphoonInstanceBuilder>
//-------------------------------------------------------------------------------------------

- (id)componentForType:(id)classOrProtocol
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"componentForType: requires the assembly to be activated with TyphooonAssemblyActivator"];
    }
    return [_factory componentForType:classOrProtocol];
}

- (NSArray *)allComponentsForType:(id)classOrProtocol
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"allComponentsForType: requires the assembly to be activated with TyphooonAssemblyActivator"];
    }
    return [_factory allComponentsForType:classOrProtocol];
}

- (id)componentForKey:(NSString *)key
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"componentForKey: requires the assembly to be activated with TyphooonAssemblyActivator"];
    }
    return [_factory componentForKey:key];
}

- (id)componentForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"componentForKey:args requires the assembly to be activated with TyphooonAssemblyActivator"];
    }
    return [_factory componentForKey:key args:args];
}

- (void)inject:(id)instance
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"inject: requires the assembly to be activated with TyphooonAssemblyActivator"];
    }
    [_factory inject:instance];
}

- (void)inject:(id)instance withSelector:(SEL)selector
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"inject:withSelector: requires the assembly to be activated with TyphooonAssemblyActivator"];
    }
    [_factory inject:instance withSelector:selector];
}


- (void)makeDefault
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"makeDefault requires the assembly to be activated with TyphooonAssemblyActivator"];
    }
    [_factory makeDefault];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)resolveCollaboratingAssemblies
{
    TyphoonCollaboratingAssemblyPropertyEnumerator
        *enumerator = [[TyphoonCollaboratingAssemblyPropertyEnumerator alloc] initWithAssembly:self];

    for (NSString *propertyName in enumerator.collaboratingAssemblyProperties) {
        [self setCollaboratingAssemblyProxyOnPropertyNamed:propertyName];
    }
}

- (void)setCollaboratingAssemblyProxyOnPropertyNamed:(NSString *)name
{
    [self setValue:[TyphoonCollaboratingAssemblyProxy proxy] forKey:name];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)activateWithFactory:(TyphoonComponentFactory *)factory
{
    _factory = factory;
}


- (NSArray *)definitions
{
    return [_definitionBuilder builtDefinitions];
}

- (TyphoonDefinition *)definitionForKey:(NSString *)key
{
    for (TyphoonDefinition *definition in [self definitions]) {
        if ([definition.key isEqualToString:key]) {
            return definition;
        }
    }
    return nil;
}

- (void)prepareForUse
{
    self.definitionSelectors = [self.adviser definitionSelectors];
    [self.adviser adviseAssembly];
}


@end