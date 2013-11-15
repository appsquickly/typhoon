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

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonComponentFactory.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "MiddleAgesAssembly.h"
#import "TyphoonSharedComponentFactoryTests.h"
#import "TyphoonBundleResource.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "ExceptionTestAssembly.h"
#import "Knight.h"
#import "CircularDependenciesAssembly.h"
#import "SingletonsChainAssembly.h"
#import "CavalryMan.h"
#import "OCLogTemplate.h"
#import "InfrastructureComponentsAssembly.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "ExtendedMiddleAgesAssembly.h"
#import "DefinitionInheritanceAssembly.h"
#import "CampaignQuest.h"
#import "Widget.h"

@interface TyphoonBlockComponentFactoryTests : TyphoonSharedComponentFactoryTests
@end

@implementation TyphoonBlockComponentFactoryTests

- (void)setUp
{
    _componentFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[MiddleAgesAssembly assembly]];
    TyphoonPropertyPlaceholderConfigurer* configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachPostProcessor:configurer];

    _exceptionTestFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[ExceptionTestAssembly assembly]];
    _circularDependenciesFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[CircularDependenciesAssembly assembly]];
    _singletonsChainFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[SingletonsChainAssembly assembly]];
    _infrastructureComponentsFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[InfrastructureComponentsAssembly assembly]];

}

- (void)test_resolves_component_using_selector
{
    MiddleAgesAssembly* assembly = (MiddleAgesAssembly*) _componentFactory;
    Knight* knight = [assembly knight];
    assertThat(knight, notNilValue());
}

- (void)test_allows_injecting_properties_with_object_instance
{
    MiddleAgesAssembly* assembly = (MiddleAgesAssembly*) _componentFactory;
    CavalryMan* knight = [assembly yetAnotherKnight];
    assertThat(knight.propertyInjectedAsInstance, notNilValue());

    LogDebug(@"%@", knight.propertyInjectedAsInstance);
}

- (void)test_allows_initialization_with_a_collection_of_assemblies
{
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
            [MiddleAgesAssembly assembly],
            [CollaboratingMiddleAgesAssembly assembly],
    ]];

    Knight* knight = [(CollaboratingMiddleAgesAssembly*) factory knightWithExternalQuest];
    LogDebug(@"Knight: %@", knight);
    assertThat(knight, notNilValue());
}

- (void)test_allows_overriding_methods_in_an_assembly
{
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
            [ExtendedMiddleAgesAssembly assembly],
    ]];

    Knight* knight = [(ExtendedMiddleAgesAssembly*) factory yetAnotherKnight];
    LogDebug(@"Knight: %@", knight);
    assertThat(knight, notNilValue());
}

#pragma mark - Definition Inheritance

- (void)test_child_missing_initializer_inherits_parent_initializer
{
    DefinitionInheritanceAssembly* factoryAssembly = [self newDefinitionInheritanceFactoryAssembly];

    Knight *childKnight = [(TyphoonBlockComponentFactory*)factoryAssembly componentForKey:@"childKnightWithConstructorDependency"];

    assertThat(childKnight, instanceOf([Knight class]));
    assertThat(childKnight.quest, instanceOf([CampaignQuest class]));
}

- (void)test_child_initializer_overrides_parent_initializer
{
    DefinitionInheritanceAssembly* factoryAssembly = [self newDefinitionInheritanceFactoryAssembly];

    Widget* childWidget = [factoryAssembly childWidgetWithDependencyOnCInheritingFromAandB];

    // want childWidget to be well-formed according to it's definition.
    assertThat(childWidget, instanceOf([Widget class]));
    assertThat(childWidget.widgetC, notNilValue());
    assertThat(childWidget.widgetC.name, equalTo(@"C"));
}

#pragma mark - Test Utility Methods

- (DefinitionInheritanceAssembly*)newDefinitionInheritanceFactoryAssembly
{
    TyphoonBlockComponentFactory* definitionInheritanceFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[DefinitionInheritanceAssembly assembly]];
    DefinitionInheritanceAssembly* factoryAssembly = (DefinitionInheritanceAssembly* )definitionInheritanceFactory;
    return factoryAssembly;
}

@end

