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



#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonAssemblyValidator.h"
#import "TyphoonAssembly.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonDefinition.h"
#import "TyphoonInjected.h"
#import "TyphoonInjectedByReference.h"
#import "TyphoonBlockComponentFactory.h"



@implementation TyphoonAssemblyValidator
{
    TyphoonDefinition *_currentDefinition;
}

- (instancetype)initWithAssembly:(TyphoonAssembly *)assembly {
    self = [super init];
    if (self)
    {
        _assembly = assembly;
    }

    return self;
}

- (void)validate
{
    [self verifyDefinitionsDoNotDirectlyCallOtherAssemblies];
}

- (void)verifyDefinitionsDoNotDirectlyCallOtherAssemblies;
{
    for (TyphoonDefinition* definition in [self.assembly definitions]) {
        _currentDefinition = definition;
        [self verifyCurrentDefinition];
    }
}

- (void)verifyCurrentDefinition {
    [self verifyInitializerInjectionNotPerformedOnOtherAssembliesByCurrentDefinition];
    [self verifyPropertyInjectionNotPerformedOnOtherAssembliesByCurrentDefinition];
}

- (void)verifyPropertyInjectionNotPerformedOnOtherAssembliesByCurrentDefinition {
    id <NSFastEnumeration> injectees = _currentDefinition.injectedProperties;

    [self verifyCurrentDefinitionWithInjectees:injectees injectionType:@"property"];
}

- (void)verifyInitializerInjectionNotPerformedOnOtherAssembliesByCurrentDefinition
{
    id <NSFastEnumeration> injectees = [[_currentDefinition initializer] injectedParameters];

    [self verifyCurrentDefinitionWithInjectees:injectees injectionType:@"initializer"];
}

- (void)verifyCurrentDefinitionWithInjectees:(id <NSFastEnumeration>)injectees injectionType:(NSString *)type
{
    for (TyphoonInjected *injected in injectees) {
        if ([injected isByReference]) {
            if ([self injectedIsFromDifferentAssembly:(TyphoonInjectedByReference *)injected]) {
                [self onInjectionOnDifferentAssemblyWithDefinitionNamed:_currentDefinition.key injectionType:type];
            }
        }
    }
}

- (BOOL)injectedIsFromDifferentAssembly:(TyphoonInjectedByReference *)injected
{
    BOOL fromSameAssembly = [self injectedIsFromCollaboratingAssemblyProxy:injected] ||
            [self injectedIsOnAssemblyItself:injected];

    return !fromSameAssembly;
}

- (BOOL)injectedIsOnAssemblyItself:(TyphoonInjectedByReference *)reference {
    return [_assembly definitionForKey:reference.reference] != nil;
}

- (BOOL)injectedIsFromCollaboratingAssemblyProxy:(TyphoonInjectedByReference *)reference {
    return reference.proxied;
}

- (void)onInjectionOnDifferentAssemblyWithDefinitionNamed:(NSObject *)object injectionType:(NSString *)type
{
    [NSException raise:TyphoonAssemblyInvalidException format:@"The definition '%@' on assembly '%@' attempts to perform %@ injection with an instance of a different assembly.\nUse a collaborating assembly proxy instead.", object, NSStringFromClass([_assembly class]), type];
}

@end


NSString const * TyphoonAssemblyInvalidException = @"TyphoonAssemblyInvalidException";