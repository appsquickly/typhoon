////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <objc/runtime.h>
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssemblyDefinitionBuilder.h"
#import "TyphoonCollaboratingAssemblyPropertyEnumerator.h"
#import "TyphoonCollaboratingAssemblyProxy.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByComponentFactory.h"
#import "TyphoonSelector.h"

static NSMutableSet *reservedSelectorsAsStrings;

@interface TyphoonAssembly () <TyphoonObjectWithCustomInjection>

@property(readwrite) NSSet *definitionSelectors;

@property(readonly) TyphoonAssemblyAdviser *adviser;

@end

@implementation TyphoonAssembly
{
    TyphoonAssemblyDefinitionBuilder *_definitionBuilder;
}


/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonAssembly *)assembly
{
    return [[self alloc] init];
}

+ (instancetype)defaultAssembly
{
    return (TyphoonAssembly *) [TyphoonComponentFactory defaultFactory];
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
    [self markSelectorReserved:@selector(asFactory)];
    [self markSelectorReserved:@selector(resolveCollaboratingAssemblies)];

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
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromInvocation:anInvocation];

    TyphoonDefinition *definition = [self buildDefinitionForSelector:anInvocation.selector args:args];

    [anInvocation retainArguments];
    [anInvocation setReturnValue:&definition];
}

- (TyphoonDefinition *)buildDefinitionForSelector:(SEL)selector args:(TyphoonRuntimeArguments *)args
{
    NSString *key = NSStringFromSelector(selector);
    return [_definitionBuilder builtDefinitionForKey:key args:args];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

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

/* ====================================================================================================================================== */
#pragma mark - <TyphoonObjectWithCustomInjection>

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return [[TyphoonInjectionByComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

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

- (TyphoonComponentFactory *)asFactory
{
    return (id)self;
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

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