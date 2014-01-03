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
#import <Typhoon/TyphoonInitializer+InstanceBuilder.h>
#import <Typhoon/TyphoonCollaboratingAssemblyProxy.h>
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "OCLogTemplate.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonInitializer.h"
#import "TyphoonInjectedParameter.h"
#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonInjectedByReference.h"

NSString const * TyphoonAssemblyInvalidException = @"TyphoonAssemblyInvalidException";

@implementation TyphoonBlockComponentFactory

/* ====================================================================================================================================== */
#pragma mark - Class Methods
+ (instancetype)factoryWithAssembly:(TyphoonAssembly*)assembly
{
    return [[self alloc] initWithAssemblies:@[assembly]];
}

+ (instancetype)factoryWithAssemblies:(NSArray*)assemblies
{
    return [[self alloc] initWithAssemblies:assemblies];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithAssembly:(TyphoonAssembly*)assembly
{
    return [self initWithAssemblies:@[assembly]];
}

- (instancetype)initWithAssemblies:(NSArray*)assemblies
{
    self = [super init];
    if (self)
    {
        for (TyphoonAssembly* assembly in assemblies)
        {
            [self buildAssembly:assembly];
        }
    }
    return self;
}

- (void)buildAssembly:(TyphoonAssembly*)assembly
{
    LogTrace(@"Building assembly: %@", NSStringFromClass([assembly class]));
    [self assertIsAssembly:assembly];

    [assembly prepareForUse];

//    TyphoonAssemblyValidator *validator = [[TyphoonAssemblyValidator alloc] initWithAssembly:assembly];
//    [validator assertDefinitionsDoNotDirectlyCallOtherAssemblies];
    [self verifyDefinitionsDoNotDirectlyCallOtherAssemblies:assembly];
    [self registerAllDefinitions:assembly];
}

#pragma mark - verifyDefinitionsDoNotDirectlyCallOtherAssemblies
- (void)verifyDefinitionsDoNotDirectlyCallOtherAssemblies:(TyphoonAssembly *)assembly
{
    for (TyphoonDefinition* definition in [assembly definitions]) {
        [self verifyDefinition:definition doesNotDirectlyCallAssemblyOtherThanAssembly:assembly];
    }
}

- (void)verifyDefinition:(TyphoonDefinition *)definition doesNotDirectlyCallAssemblyOtherThanAssembly:(TyphoonAssembly *)assembly
{
    [self verifyDefinition:definition doesNotPerformInitializerInjectionOnAssembliesOtherThanAssembly:assembly];
    [self verifyDefinition:definition doesNotPerformPropertyInjectionOnAssembliesOtherThanAssembly:assembly];
}

- (void)verifyDefinition:(TyphoonDefinition *)definition doesNotPerformInitializerInjectionOnAssembliesOtherThanAssembly:(TyphoonAssembly *)assembly
{
    id <NSFastEnumeration> injectees = [[definition initializer] injectedParameters];

    [self                           verifyDefinition:definition
doesNotPerformInjectionOnAssembliesOtherThanAssembly:assembly
                                           injectees:injectees
                                       injectionType:@"initializer"];
}

- (void)verifyDefinition:(TyphoonDefinition *)definition doesNotPerformPropertyInjectionOnAssembliesOtherThanAssembly:(TyphoonAssembly *)assembly
{
    id <NSFastEnumeration> injectees = definition.injectedProperties;

    [self                           verifyDefinition:definition
doesNotPerformInjectionOnAssembliesOtherThanAssembly:assembly
                                           injectees:injectees
                                       injectionType:@"property"];
}

- (void)verifyDefinition:(TyphoonDefinition *)definition doesNotPerformInjectionOnAssembliesOtherThanAssembly:(TyphoonAssembly *)assembly injectees:(id <NSFastEnumeration>)injectees injectionType:(NSString *)injectionType
{
    for (TyphoonInjected *injected in injectees) {
        if ([injected isByReference]) {
            if ([self injected:(TyphoonInjectedByReference *)injected isFromDifferentAssemblyThanAssembly:assembly]) {
                [self onInjectionWithDefinitionNamed:definition.key fromDifferentAssemblyThanAssembly:assembly injectionType:injectionType];
            }
        }
    }
}

- (BOOL)injected:(TyphoonInjectedByReference *)injected isFromDifferentAssemblyThanAssembly:(TyphoonAssembly *)assembly {
    BOOL fromSameAssembly = [self injectedIsFromCollaboratingAssemblyProxy:injected] ||
            [self injectedIsOnAssemblyItself:injected currentAssembly:assembly];

    return !fromSameAssembly;
}

- (BOOL)injectedIsOnAssemblyItself:(TyphoonInjectedByReference *)reference currentAssembly:(TyphoonAssembly *)assembly {
    return [assembly definitionForKey:reference.reference] != nil;
}

- (BOOL)injectedIsFromCollaboratingAssemblyProxy:(TyphoonInjectedByReference *)reference {
    return reference.fromCollaboratingAssemblyProxy;
}

- (void)onInjectionWithDefinitionNamed:(NSObject *)object fromDifferentAssemblyThanAssembly:(TyphoonAssembly *)assembly injectionType:(NSString *)type
{
    [NSException raise:TyphoonAssemblyInvalidException format:@"The definition '%@' on assembly '%@' attempts to perform %@ injection with an instance of a different assembly.\nUse a collaborating assembly proxy instead.", object, NSStringFromClass([assembly class]), type];
}

#pragma mark - Rest of Initialization
- (void)assertIsAssembly:(TyphoonAssembly*)assembly
{
    if (![assembly isKindOfClass:[TyphoonAssembly class]]) //
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@",
                                                             NSStringFromClass([assembly class]),
                                                             NSStringFromClass([TyphoonAssembly class])];
    }
}

- (void)registerAllDefinitions:(TyphoonAssembly*)assembly
{
    NSArray* definitions = [assembly definitions];
    for (TyphoonDefinition* definition in definitions)
    {
        [self register:definition];
    }
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)forwardInvocation:(NSInvocation*)invocation
{
    NSString* componentKey = NSStringFromSelector([invocation selector]);
    LogTrace(@"Component key: %@", componentKey);

    [invocation setSelector:@selector(componentForKey:)];
    [invocation setArgument:&componentKey atIndex:2];
    [invocation invoke];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector])
    {
        return [[self class] instanceMethodSignatureForSelector:aSelector];
    }
    else
    {
        return [[self class] instanceMethodSignatureForSelector:@selector(componentForKey:)];
    }
}

@end