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



#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "OCLogTemplate.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblyPropertyInjectionPostProcessor.h"
#import "TyphoonDefinition+Internal.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonInstancePostProcessor.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonPreattachedComponentsRegisterer.h"
#import "TyphoonMemoryManagementUtils.h"

@interface TyphoonComponentFactory (Private)

- (TyphoonDefinition *)definitionForKey:(NSString *)key;

- (void)loadIfNeeded;

@end


@implementation TyphoonBlockComponentFactory

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//-------------------------------------------------------------------------------------------

+ (id)factoryWithAssembly:(TyphoonAssembly *)assembly
{
    return [[self alloc] initWithAssemblies:@[assembly]];
}

+ (id)factoryWithAssemblies:(NSArray *)assemblies
{
    return [[self alloc] initWithAssemblies:assemblies];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)initWithAssembly:(TyphoonAssembly *)assembly
{
    return [self initWithAssemblies:@[assembly]];
}

- (id)initWithAssemblies:(NSArray *)assemblies
{
    self = [super init];
    if (self) {
        [self attachDefinitionPostProcessor:[TyphoonAssemblyPropertyInjectionPostProcessor new]];
        TyphoonPreattachedComponentsRegisterer *preattachedComponentsRegisterer = [[TyphoonPreattachedComponentsRegisterer alloc] initWithComponentFactory:self];
        
        for (TyphoonAssembly *assembly in assemblies) {
            [preattachedComponentsRegisterer doRegistrationForAssembly:assembly];
            [self buildAssembly:assembly];
            [assembly activateWithFactory:self collaborators:[NSSet setWithArray:assemblies]];
        }
        
        [TyphoonMemoryManagementUtils makeFactory:self retainAssemblies:[NSSet setWithArray:assemblies]];
    }
    return self;
}

- (void)buildAssembly:(TyphoonAssembly*)assembly
{
    LogTrace(@"Building assembly: %@", NSStringFromClass([assembly class]));
    [self assertIsAssembly:assembly];

    [assembly prepareForUse];

    [self registerAllDefinitions:assembly];
}

- (void)assertIsAssembly:(TyphoonAssembly *)assembly
{
    if (![assembly isKindOfClass:[TyphoonAssembly class]]) {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@",
                                                             NSStringFromClass([assembly class]),
                                                             NSStringFromClass([TyphoonAssembly class])];
    }
}

- (void)registerAllDefinitions:(TyphoonAssembly *)assembly
{
    NSArray *definitions = [assembly definitions];
    for (TyphoonDefinition *definition in definitions) {
        [self registerDefinition:definition];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *componentKey = NSStringFromSelector([invocation selector]);
    LogTrace(@"Component key: %@", componentKey);

    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromInvocation:invocation];

    NSInvocation *internalInvocation =
            [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(componentForKey:args:)]];
    [internalInvocation setSelector:@selector(componentForKey:args:)];
    [internalInvocation setArgument:&componentKey atIndex:2];
    [internalInvocation setArgument:&args atIndex:3];
    [internalInvocation invokeWithTarget:self];

    void *returnValue;
    [internalInvocation getReturnValue:&returnValue];
    [invocation setReturnValue:&returnValue];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector]) {
        return [[self class] instanceMethodSignatureForSelector:aSelector];
    }
    
    NSString *componentKey = NSStringFromSelector(aSelector);
    TyphoonDefinition *definition = [self definitionForKey:componentKey];
    TyphoonAssembly *assembly = definition.assembly;
    
    if (assembly) {
        return [assembly methodSignatureForSelector:aSelector];
    }
    
    // Last resort.
    return [TyphoonIntrospectionUtils methodSignatureWithArgumentsAndReturnValueAsObjectsFromSelector:aSelector];
}

@end
