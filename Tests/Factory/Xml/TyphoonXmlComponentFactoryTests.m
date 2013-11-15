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


#import "TyphoonSharedComponentFactoryTests.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonBundleResource.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonXmlComponentFactory.h"
#import "Quest.h"
#import "Knight.h"
#import "CampaignQuest.h"

@interface TyphoonXmlComponentFactoryTests : TyphoonSharedComponentFactoryTests
@end

@implementation TyphoonXmlComponentFactoryTests

- (void)setUp
{
    _componentFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"MiddleAgesAssembly.xml"];
    TyphoonPropertyPlaceholderConfigurer* configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachPostProcessor:configurer];

    _exceptionTestFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"ExceptionTestAssembly.xml"];
    _circularDependenciesFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"CircularDependenciesAssembly.xml"];
    _singletonsChainFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"SingletonsChainAssembly.xml"];
    _infrastructureComponentsFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"InfratructureComponentsAssembly.xml"];
  
}

- (void)test_injects_initializer_by_value
{
    id<Quest> anotherQuest = [_componentFactory componentForKey:@"anotherQuest"];
    assertThat(anotherQuest, notNilValue());
    assertThat(anotherQuest.imageUrl, notNilValue());
    NSLog(@"Another quest: %@", anotherQuest);
}

@end