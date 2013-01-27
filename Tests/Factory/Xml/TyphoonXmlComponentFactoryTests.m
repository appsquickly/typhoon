////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "Typhoon.h"
#import "Knight.h"
#import "ClassADependsOnB.h"
#import "Sword.h"
#import "CavalryMan.h"
#import "CampaignQuest.h"

@interface TyphoonXmlComponentFactoryTests : SenTestCase
@end

@implementation TyphoonXmlComponentFactoryTests
{
    TyphoonComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"MiddleAgesAssembly.xml"];
    TyphoonPropertyPlaceholderConfigurer* configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachMutator:configurer];
    [_componentFactory makeDefault];
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)test_property_injection_by_reference
{
    Knight* knight = [[TyphoonXmlComponentFactory defaultFactory] componentForKey:@"knight"];

    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    assertThat([knight.quest questName], equalTo(@"Campaign Quest"));
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));


}

- (void)test_mixed_initializer_and_property_injection
{
    Knight* anotherKnight = [[TyphoonXmlComponentFactory defaultFactory] componentForKey:@"anotherKnight"];
    NSLog(@"Here's another knight: %@", anotherKnight);
    assertThat(anotherKnight.quest, notNilValue());
    assertThatBool(anotherKnight.hasHorseWillTravel, equalToBool(YES));
}

/* ====================================================================================================================================== */
#pragma mark factory method injection

- (void)test_factory_method_injection
{
    NSURL* url = [_componentFactory componentForKey:@"serviceUrl"];
    NSLog(@"Here's the url: %@", url);
}

- (void)test_factory_method_injection_raises_exception_if_required_class_not_set
{
    TyphoonXmlComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"ExceptionTestAssembly.xml"];
    @try
    {
        NSURL* url = [factory componentForKey:@"anotherServiceUrl"];
        NSLog(@"Here's the url: %@", url);
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
            @"Unless the type is primitive (int, BOOL, etc), initializer injection requires the required class to be specified. Eg: <argument parameterName=\"string\" value=\"http://dev.foobar.com/service/\" required-class=\"NSString\" />"));
    }

}

- (void)test_returns_component_from_factory_component
{
    Sword* sword = [_componentFactory componentForKey:@"blueSword"];
    assertThat([sword description], equalTo(@"A bright blue sword with orange pom-poms at the hilt."));
}

/* ====================================================================================================================================== */
#pragma mark - Circular dependencies.

- (void)test_prevents_circular_dependencies_by_reference
{
    TyphoonXmlComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"CircularDependenciesAssembly.xml"];

    @try
    {
        ClassADependsOnB* classA = [factory componentForKey:@"classA"];
        NSLog(@"Class A: %@", classA); //Suppress unused var compiler warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Circular dependency detected: {(\n    classB,\n    classA\n)}"));
    }
}

- (void)test_prevents_circular_dependencies_by_type
{
    TyphoonXmlComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"CircularDependenciesAssembly.xml"];

    @try
    {
        ClassADependsOnB* classA = [factory componentForType:[ClassADependsOnB class]];
        NSLog(@"Class A: %@", classA); //Suppress unused var compiler warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        NSLog(@"%@", [e description]);
        assertThat([e description], equalTo(@"Circular dependency detected: {(\n    classB,\n    classA\n)}"));
    }
}


/* ====================================================================================================================================== */
#pragma mark initializer injection

- (void)test_raises_exception_for_invalid_selector_name
{
    TyphoonXmlComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"ExceptionTestAssembly.xml"];

    @try
    {
        NSString* aString = [factory componentForKey:@"aBlaString"];
        NSLog(@"A string: %@", aString); //Suppress unused var compiler warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
            @"Class method 'stringWithBlingBlaBla' not found on 'NSString'. Did you include the required ':' characters to signify arguments?"));
    }
}

/* ====================================================================================================================================== */
#pragma mark Property-based configuration

- (void)test_resolves_property_values
{
    TyphoonXmlComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"PropertyPlaceholderAssembly.xml"];
    TyphoonPropertyPlaceholderConfigurer*  configurer = [TyphoonPropertyPlaceholderConfigurer configurer];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [factory attachMutator:configurer];

    Knight* knight = [factory componentForKey:@"knight"];
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));

    CavalryMan* anotherKnight = [factory componentForKey:@"anotherKnight"];
    assertThatBool(anotherKnight.hasHorseWillTravel, equalToBool(NO));

}

@end
