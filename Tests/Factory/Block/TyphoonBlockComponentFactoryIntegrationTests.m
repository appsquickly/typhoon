////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
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

#import "Moat.h"
#import "Castle.h"

@interface TyphoonBlockComponentFactoryIntegrationTests : TyphoonSharedComponentFactoryTests
@end

@implementation TyphoonBlockComponentFactoryIntegrationTests


- (void)setUp
{
    _componentFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[MiddleAgesAssembly assembly]];
    TyphoonPropertyPlaceholderConfigurer* configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachMutator:configurer];

    _exceptionTestFactory = [[TyphoonBlockComponentFactory  alloc] initWithAssembly:[ExceptionTestAssembly assembly]];
    _circularDependenciesFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[CircularDependenciesAssembly assembly]];
}

- (void)test_resolves_component_using_selector
{
    MiddleAgesAssembly* assembly = (MiddleAgesAssembly *)_componentFactory;
    Knight* knight = [assembly knight];
    assertThat(knight, notNilValue());
}

- (void)test_resolves_parameterized_component_using_selector
{
    MiddleAgesAssembly* assembly = (MiddleAgesAssembly *)_componentFactory;
    
    Moat *lavaMoat = [assembly moatFilledWithLava];
    assertThat(lavaMoat, instanceOf([Moat class]));
    
    Castle* castle = [assembly castleWithMoat:lavaMoat];
    assertThat(castle, instanceOf([Castle class]));
    assertThat(castle.moat, sameInstance(lavaMoat));
}




@end

