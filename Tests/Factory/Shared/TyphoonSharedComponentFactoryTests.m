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
#import "TyphoonSharedComponentFactoryTests.h"



@implementation TyphoonSharedComponentFactoryTests


- (void)invokeTest
{
    BOOL abstractTest = [self isMemberOfClass:[TyphoonSharedComponentFactoryTests class]];
    if (!abstractTest)
    {
        [super invokeTest];
    }
    else
    {
        NSLog(@"Abstract test - implemented in sub-classes.");
    }
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)test_injects_properties_by_reference_and_by_value
{
    Knight* knight = [_componentFactory componentForKey:@"knight"];

    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    assertThat([knight.quest questName], equalTo(@"Campaign Quest"));
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));
}

- (void)test_mixed_initializer_and_property_injection
{
    Knight* anotherKnight = [_componentFactory componentForKey:@"anotherKnight"];
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
    @try
    {
        NSURL* url = [_exceptionTestFactory componentForKey:@"anotherServiceUrl"];
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
    TyphoonPropertyPlaceholderConfigurer* configurer = [TyphoonPropertyPlaceholderConfigurer configurer];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [factory attachMutator:configurer];

    Knight* knight = [factory componentForKey:@"knight"];
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));

    CavalryMan* anotherKnight = [factory componentForKey:@"anotherKnight"];
    assertThatBool(anotherKnight.hasHorseWillTravel, equalToBool(NO));

}

@end
