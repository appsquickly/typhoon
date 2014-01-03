//
// Created by Robert Gilliam on 1/3/14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonAssemblyValidator.h"
#import "TyphoonAssembly.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonDefinition.h"
#import "TyphoonInjected.h"
#import "TyphoonInitializer.h"
#import "TyphoonInjectedByReference.h"
#import "TyphoonBlockComponentFactory.h"


@implementation TyphoonAssemblyValidator
{

}

- (instancetype)initWithAssembly:(TyphoonAssembly *)assembly {
    self = [super init];
    if (self)
    {
        _assembly = assembly;
    }

    return self;
}

- (void)validate {
    [self verifyDefinitionsDoNotDirectlyCallOtherAssemblies:_assembly];
}

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

@end