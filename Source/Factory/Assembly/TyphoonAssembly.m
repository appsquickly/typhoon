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
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "OCLogTemplate.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonCollaboratingAssembliesCollector.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonMemoryManagementUtils.h"
#import "TyphoonAssemblyAccessor.h"

static NSMutableSet *reservedSelectorsAsStrings;

@interface TyphoonAssembly ()<TyphoonObjectWithCustomInjection>

@property (readwrite) NSSet *definitionSelectors;
@property (readwrite) NSArray *preattachedInfrastructureComponents;

@property (readwrite) NSDictionary *assemblyClassPerDefinitionKey;

@property (readonly) TyphoonAssemblyAdviser *adviser;
@property (readonly, unsafe_unretained) TyphoonComponentFactory *factory;
@property (readonly) TyphoonCollaboratingAssembliesCollector *collector;

@property (nonatomic, strong) TyphoonAssemblyAccessor *accessor;

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
    return (id)[TyphoonComponentFactory defaultFactory];
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
    [self markSelectorReserved:@selector(proxyCollaboratingAssembliesPriorToActivation)];
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
    @synchronized (self) {
        if (_factory) {
            [_factory forwardInvocation:anInvocation];
        } else {
            TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromInvocation:anInvocation];
            NSString *key = NSStringFromSelector(anInvocation.selector);
            TyphoonDefinition *definition = [_definitionBuilder builtDefinitionForKey:key args:args];

            [anInvocation retainArguments];
            [anInvocation setReturnValue:&definition];
        }
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
        _collector = [[TyphoonCollaboratingAssembliesCollector alloc] initWithAssemblyClass:[self class]];
        _preattachedInfrastructureComponents = [NSArray array];

        _accessor = [TyphoonAssemblyAccessor new];
        _accessor.assembly = self;
        _accessor.definitionBuilder = _definitionBuilder;

        [self proxyCollaboratingAssembliesPriorToActivation];
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
    [NSException raise:NSInternalInconsistencyException
                format:@"componentForType: requires the assembly to be activated."];
    return nil;
}

- (NSArray *)allComponentsForType:(id)classOrProtocol
{
    [NSException raise:NSInternalInconsistencyException
                format:@"allComponentsForType: requires the assembly to be activated."];
    return nil;
}

- (id)componentForKey:(NSString *)key
{
    [NSException raise:NSInternalInconsistencyException
                format:@"componentForKey: requires the assembly to be activated."];
    return nil;
}

- (id)componentForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    [NSException raise:NSInternalInconsistencyException
                format:@"componentForKey:args requires the assembly to be activated."];
    return nil;
}

- (void)inject:(id)instance
{
    [NSException raise:NSInternalInconsistencyException format:@"inject: requires the assembly to be activated."];
}

- (void)inject:(id)instance withSelector:(SEL)selector
{
    [NSException raise:NSInternalInconsistencyException
                format:@"inject:withSelector: requires the assembly to be activated."];
}


- (void)makeDefault
{
    [NSException raise:NSInternalInconsistencyException
                format:@"makeDefault requires the assembly to be activated."];
}

- (void)attachDefinitionPostProcessor:(id<TyphoonDefinitionPostProcessor>)postProcessor
{
    if (!_factory) {
        [self preattachInfrastructureComponent:postProcessor];
    }
}

- (void)attachInstancePostProcessor:(id<TyphoonInstancePostProcessor>)postProcessor
{
    if (!_factory) {
        [self preattachInfrastructureComponent:postProcessor];
    }
}

- (void)attachTypeConverter:(id<TyphoonTypeConverter>)typeConverter
{
    if (!_factory) {
        [self preattachInfrastructureComponent:typeConverter];
    }
}

- (id)objectForKeyedSubscript:(id)key
{
    [NSException raise:NSInternalInconsistencyException
                format:@"objectForKeyedSubscript: requires the assembly to be activated."];
    return nil;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (instancetype)activated
{
    if (self.factory) {
        return (id)self.accessor;
    } else {
        return [self activatedWithCollaboratingAssemblies:nil];
    }
}

- (instancetype)activatedWithConfigResourceName:(NSString *__nonnull)resourceName
{
    TyphoonConfigPostProcessor *processor = [TyphoonConfigPostProcessor processor];
    [processor useResourceWithName:resourceName];
    return [self activatedWithCollaboratingAssemblies:nil postProcessors:@[processor]];
}

- (instancetype)activatedWithCollaboratingAssemblies:(NSArray *__nullable)assemblies
{
    return [self activatedWithCollaboratingAssemblies:assemblies postProcessors:nil];
}

- (instancetype)activatedWithCollaboratingAssemblies:(NSArray *__nullable)assemblies postProcessors:(NSArray *__nullable)postProcessors
{
    [self attachProcessors:postProcessors];

    NSMutableSet *reconciledAssemblies = [NSMutableSet setWithArray:[@[self] arrayByAddingObjectsFromArray:assemblies]];
    NSMutableSet *assembliesToRemove = [[NSMutableSet alloc] init];

    NSSet *collaboratingAssemblies = [self.collector collectCollaboratingAssemblies];
    for (TyphoonAssembly *collaboratingAssembly in collaboratingAssemblies) {

        for (TyphoonAssembly *overrideCandidate in assemblies) {
            if ([collaboratingAssembly class] != [overrideCandidate class] &&
                    [[overrideCandidate class] isSubclassOfClass:[collaboratingAssembly class]]) {

                [assembliesToRemove addObject:collaboratingAssembly];
                LogInfo(@"%@ will act in place of assembly with class: %@", [overrideCandidate class],
                        [collaboratingAssembly class]);
            }
        }
        if (![self assemblyWithType:[collaboratingAssembly class] in:reconciledAssemblies]) {
            [reconciledAssemblies addObject:collaboratingAssembly];
        }
    }

    for (TyphoonAssembly *assembly in assembliesToRemove) {
        [reconciledAssemblies removeObject:assembly];
    }

    TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:
                                                                                  [reconciledAssemblies allObjects]];
    [TyphoonMemoryManagementUtils makeAssemblies:reconciledAssemblies retainFactory:factory];

    return (id)self.accessor;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)attachProcessors:(NSArray *)postProcessors
{
    _preattachedInfrastructureComponents =
            [_preattachedInfrastructureComponents arrayByAddingObjectsFromArray:postProcessors];
}

- (void)proxyCollaboratingAssembliesPriorToActivation
{
    TyphoonCollaboratingAssemblyPropertyEnumerator *enumerator = [[TyphoonCollaboratingAssemblyPropertyEnumerator alloc]
            initWithAssembly:self];

    NSMutableDictionary *collaboratingAssemblies = [NSMutableDictionary new];

    for (NSString *propertyName in enumerator.collaboratingAssemblyProperties) {
        TyphoonCollaboratingAssemblyProxy *proxy = [TyphoonCollaboratingAssemblyProxy proxy];
        [self setValue:proxy forKey:propertyName];
        collaboratingAssemblies[propertyName] = proxy;
    }

    _accessor.collaboratingAssemblies = collaboratingAssemblies;
}

- (void)activateWithFactory:(TyphoonComponentFactory *)factory collaborators:(NSSet *)collaborators
{
    _factory = factory;
    _accessor.factory = _factory;

    NSMutableDictionary *collaboratingAssemblies = [NSMutableDictionary new];

    for (NSString *propertyName in [self typhoonPropertiesUpToParentClass:[TyphoonAssembly class]]) {
        TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:propertyName];
        if (descriptor.typeBeingDescribed == [TyphoonAssembly class]) {
            TyphoonAssembly *collaborator = [self assemblyConformingTo:descriptor.declaredProtocol in:collaborators];
            if (!collaborator) {
                LogInfo(@"*** Warning *** Can't find collaborating assembly that conforms to protocol %@. Is this "
                        "intentional? The property '%@' in class %@ will be left as nil.", descriptor.declaredProtocol,
                        propertyName, NSStringFromClass([self class]));
            }
            [self setValue:collaborator forKey:propertyName];
            collaboratingAssemblies[propertyName] = collaborator;
        } else if ([descriptor.typeBeingDescribed isSubclassOfClass:[TyphoonAssembly class]]) {
            TyphoonAssembly *collaborator = [self assemblyWithType:descriptor.typeBeingDescribed in:collaborators];
            if (!collaborator) {
                LogInfo(@"*** Warning *** Can't find assembly of type %@. Is this intentional? The property '%@' "
                        "in class %@ will be left as nil.", descriptor.typeBeingDescribed, propertyName,
                        NSStringFromClass([self class]));
            }
            [self setValue:collaborator forKey:propertyName];
            collaboratingAssemblies[propertyName] = collaborator;
        }
    }

    _accessor.collaboratingAssemblies = collaboratingAssemblies;
}

- (TyphoonAssembly *)assemblyConformingTo:(NSString *)protocolName in:(NSSet *)assemblies
{
    for (TyphoonAssembly *assembly in assemblies) {

        if ([[assembly class] conformsToProtocol:NSProtocolFromString(protocolName)]) {
            return assembly;
        }
    }
    return nil;
}

- (TyphoonAssembly *)assemblyWithType:(Class)type in:(NSSet *)assemblies
{
    for (TyphoonAssembly *assembly in assemblies) {
        if ([[assembly class] isSubclassOfClass:type]) {
            return assembly;
        }
    }
    return nil;
}

- (NSArray *)definitions
{
    return [_definitionBuilder builtDefinitions];
}

- (void)prepareForUse
{
    self.definitionSelectors = [self.adviser definitionSelectors];
    self.assemblyClassPerDefinitionKey = [self.adviser assemblyClassPerDefinitionKey];
}

- (Class)assemblyClassForKey:(NSString *)key
{
    if (self.assemblyClassPerDefinitionKey) {
        return self.assemblyClassPerDefinitionKey[key];
    } else {
        return [self class];
    }
}

- (void)preattachInfrastructureComponent:(id)component
{
    _preattachedInfrastructureComponents = [_preattachedInfrastructureComponents arrayByAddingObject:component];
}

@end
