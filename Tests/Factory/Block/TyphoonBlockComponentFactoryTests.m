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

@interface TyphoonBlockComponentFactoryTests : TyphoonSharedComponentFactoryTests
@end

@implementation TyphoonBlockComponentFactoryTests


- (void)setUp
{
    _componentFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[MiddleAgesAssembly assembly]];
    TyphoonPropertyPlaceholderConfigurer* configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachMutator:configurer];

    _exceptionTestFactory = [[TyphoonBlockComponentFactory  alloc] initWithAssembly:[ExceptionTestAssembly assembly]];
    _circularDependenciesFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[CircularDependenciesAssembly assembly]];
    _singletonsChainFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[SingletonsChainAssembly assembly]];
}

- (void)test_resolves_component_using_selector
{
    MiddleAgesAssembly* assembly = (MiddleAgesAssembly *)_componentFactory;
    Knight* knight = [assembly knight];
    assertThat(knight, notNilValue());
}

- (void)test_allows_injecting_properties_with_object_instance
{
    MiddleAgesAssembly* assembly = (MiddleAgesAssembly *)_componentFactory;
    CavalryMan* knight = [assembly yetAnotherKnight];
    assertThat(knight.propertyInjectedAsInstance, notNilValue());

    LogDebug(@"%@", knight.propertyInjectedAsInstance);
}

@end

