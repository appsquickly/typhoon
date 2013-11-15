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
#import "Widget.h"

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

#pragma mark - Definition Inheritance

- (void)test_has_parent
{
    TyphoonComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"DefinitionInheritanceAssembly.xml"];
    id child = [factory componentForKey:@"child"];

    assertThat(child, notNilValue());
}

- (void)test_child_missing_initializer_inherits_parent_initializer
{
    TyphoonComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"DefinitionInheritanceAssembly.xml"];
    Knight *child = [factory componentForKey:@"childKnightWithConstructorDependency"];

    assertThat(child, instanceOf([Knight class]));
    assertThat(child.quest, instanceOf([CampaignQuest class]));
}

- (void)test_child_initializer_overrides_parent_initializer
{
    TyphoonComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"DefinitionInheritanceAssembly.xml"];
    Widget *child = [factory componentForKey:@"childWidgetWithDependencyOnCInheritingFromAandB"];

    // want childWidget to be well-formed according to it's definition.
    assertThat(child, instanceOf([Widget class]));
    assertThat(child.widgetC, notNilValue());
    assertThat(child.widgetC.name, equalTo(@"C"));

}

@end