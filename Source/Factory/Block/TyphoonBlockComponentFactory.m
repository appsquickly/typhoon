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



#import <objc/runtime.h>
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "OCLogTemplate.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblyPropertyInjectionPostProcessor.h"
#import "TyphoonInjection.h"
#import "TyphoonIntrospectionUtils.h"

@interface TyphoonComponentFactory (Private)

- (TyphoonDefinition *)definitionForKey:(NSString *)key;

- (void)loadIfNeeded;

@end

@implementation TyphoonBlockComponentFactory

- (id)asAssembly
{
    return self;
}

- (TyphoonComponentFactory *)asFactory
{
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (id)factoryWithAssembly:(TyphoonAssembly *)assembly
{
    return [[self alloc] initWithAssemblies:@[assembly]];
}

+ (id)factoryWithAssemblies:(NSArray *)assemblies
{
    return [[self alloc] initWithAssemblies:assemblies];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithAssembly:(TyphoonAssembly *)assembly
{
    return [self initWithAssemblies:@[assembly]];
}

- (id)initWithAssemblies:(NSArray *)assemblies
{
    self = [super init];
    if (self) {
        [self attachPostProcessor:[TyphoonAssemblyPropertyInjectionPostProcessor new]];
        for (TyphoonAssembly *assembly in assemblies) {
            [self buildAssembly:assembly];
        }
    }
    return self;
}

- (void)buildAssembly:(TyphoonAssembly *)assembly
{
    LogTrace(@"Building assembly: %@", NSStringFromClass([assembly class]));
    [self assertIsAssembly:assembly];

    [assembly prepareForUse];

    [self registerAllDefinitions:assembly];
}

- (void)assertIsAssembly:(TyphoonAssembly *)assembly
{
    if (![assembly isKindOfClass:[TyphoonAssembly class]]) //
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@", NSStringFromClass([assembly class]),
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


/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

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
    else {
        return [TyphoonIntrospectionUtils methodSignatureWithArgumentsAndReturnValueAsObjectsFromSelector:aSelector];
    }
}

@end