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
#import <objc/message.h>
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
#import "TyphoonIntrospectionUtils.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"
#import "TyphoonBlockComponentFactory.h"

static NSMutableSet *reservedSelectorsAsStrings;

@interface TyphoonAssembly ()<TyphoonObjectWithCustomInjection>

@property (readwrite) NSSet *definitionSelectors;

@property (readonly) TyphoonAssemblyAdviser *adviser;
@property (readonly) TyphoonComponentFactory *factory;

@end

@implementation TyphoonAssembly
{
    TyphoonAssemblyDefinitionBuilder *_definitionBuilder;
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


+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return YES;
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
#pragma mark - <TyphoonComponentFactory>
//-------------------------------------------------------------------------------------------

- (id)componentForType:(id)classOrProtocol
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"componentForType: requires the assembly to be activated."];
    }
    return [_factory componentForType:classOrProtocol];
}

- (NSArray *)allComponentsForType:(id)classOrProtocol
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"allComponentsForType: requires the assembly to be activated."];
    }
    return [_factory allComponentsForType:classOrProtocol];
}

- (id)componentForKey:(NSString *)key
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"componentForKey: requires the assembly to be activated."];
    }
    return [_factory componentForKey:key];
}

- (id)componentForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"componentForKey:args requires the assembly to be activated."];
    }
    return [_factory componentForKey:key args:args];
}

- (void)inject:(id)instance
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException format:@"inject: requires the assembly to be activated."];
    }
    [_factory inject:instance];
}

- (void)inject:(id)instance withSelector:(SEL)selector
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"inject:withSelector: requires the assembly to be activated."];
    }
    [_factory inject:instance withSelector:selector];
}


- (void)makeDefault
{
    if (!_factory) {
        [NSException raise:NSInternalInconsistencyException
            format:@"makeDefault requires the assembly to be activated."];
    }
    [_factory makeDefault];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (instancetype)activate
{
    return [self activateWithCollaboratingAssemblies:nil];
}

- (instancetype)activateWithCollaboratingAssemblies:(NSArray *)assemblies
{
    NSMutableArray *collaborators = [[NSMutableArray alloc] initWithArray:@[self]];
    for (NSString *propertyName in [self collaboratingAssemblyPropertyNames]) {
        Class assemblyClass = [self typhoonTypeForPropertyNamed:propertyName].typeBeingDescribed;
        if (assemblyClass != [TyphoonAssembly class]) {
            for (Class overrideCandidate in assemblies) {
                if (overrideCandidate != assemblyClass && [overrideCandidate isSubclassOfClass:assemblyClass]) {
                    LogInfo(@"%@ will act in place of assembly with class: %@", overrideCandidate, assemblyClass);
                    assemblyClass = overrideCandidate;
                }
            }
            TyphoonAssembly *instance = ((TyphoonAssembly *(*)(Class, SEL))objc_msgSend)(assemblyClass,
                @selector(assembly));
            [collaborators addObject:instance];
        }
    }

    TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:collaborators];
    for (TyphoonAssembly *assembly in collaborators) {
        [assembly activateWithFactory:factory collaborators:collaborators];
    }
    return self;
}



//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)resolveCollaboratingAssemblies
{
    TyphoonCollaboratingAssemblyPropertyEnumerator *enumerator = [[TyphoonCollaboratingAssemblyPropertyEnumerator alloc]
        initWithAssembly:self];

    for (NSString *propertyName in enumerator.collaboratingAssemblyProperties) {
        [self setCollaboratingAssemblyProxyOnPropertyNamed:propertyName];
    }
}

- (void)setCollaboratingAssemblyProxyOnPropertyNamed:(NSString *)name
{
    [self setValue:[TyphoonCollaboratingAssemblyProxy proxy] forKey:name];
}

- (void)activateWithFactory:(TyphoonComponentFactory *)factory collaborators:(NSArray *)collaborators
{
    _factory = factory;
    for (NSString *propertyName in [self collaboratingAssemblyPropertyNames]) {
        TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:propertyName];
        if (descriptor.typeBeingDescribed == [TyphoonAssembly class]) {
            TyphoonAssembly *collaborator = [self assemblyConformingTo:descriptor.declaredProtocol in:collaborators];
            if (!collaborator) {
                LogInfo(@"*** Warning *** Can't find collaborating assembly that conforms to protocol %@. Is this "
                    "intentional? The property '%@' in class %@ will be left as nil.", descriptor.declaredProtocol,
                    propertyName, NSStringFromClass([self class]));
            }
            [self setValue:collaborator forKey:propertyName];
        }
        else if ([descriptor.typeBeingDescribed isSubclassOfClass:[TyphoonAssembly class]]) {
            TyphoonAssembly *collaborator = [self assemblyWithType:descriptor.typeBeingDescribed in:collaborators];
            if (!collaborator) {
                LogInfo(@"*** Warning *** Can't find assembly of type %@. Is this intentional? The property '%@' "
                    "in class %@ will be left as nil.", descriptor.typeBeingDescribed, propertyName,
                    NSStringFromClass([self class]));
            }
            [self setValue:collaborator forKey:propertyName];
        }
    }
}

- (NSSet *)collaboratingAssemblyPropertyNames
{
    NSMutableArray *collaboratingAssemblyPropertyNames = [[NSMutableArray alloc] init];
    NSSet *properties = [TyphoonIntrospectionUtils propertiesForClass:[self class]
        upToParentClass:[TyphoonAssembly class]];

    for (NSString *propertyName in properties) {
        TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:propertyName];
        if ([descriptor.typeBeingDescribed isSubclassOfClass:[TyphoonAssembly class]]) {
            [collaboratingAssemblyPropertyNames addObject:propertyName];
        }
    }
    return [NSSet setWithArray:collaboratingAssemblyPropertyNames];
}


- (TyphoonAssembly *)assemblyConformingTo:(NSString *)protocolName in:(NSArray *)assemblies
{
    for (TyphoonAssembly *assembly in assemblies) {

        if ([[assembly class] conformsToProtocol:NSProtocolFromString(protocolName)]) {
            return assembly;
        }
    }
    return nil;
}

- (TyphoonAssembly *)assemblyWithType:(Class)type in:(NSArray *)assemblies
{
    for (TyphoonAssembly *assembly in assemblies) {
        if ([assembly class] == type) {
            return assembly;
        }
    }
    return nil;
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