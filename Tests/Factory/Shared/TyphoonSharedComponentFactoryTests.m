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
#import "Sword.h"
#import "CavalryMan.h"
#import "TyphoonSharedComponentFactoryTests.h"
#import "ClassBDependsOnA.h"
#import "ClassADependsOnB.h"
#import "ClassCDependsOnDAndE.h"
#import "ClassDDependsOnC.h"
#import "ClassEDependsOnC.h"
#import "UnsatisfiableClassFDependsOnGInInitializer.h"
#import "SingletonB.h"
#import "SingletonC.h"
#import "SingletonD.h"
#import "CircularDependenciesAssembly.h"

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
    CavalryMan* anotherKnight = [_componentFactory componentForKey:@"anotherKnight"];
    NSLog(@"Here's another knight: %@", anotherKnight);
    assertThat(anotherKnight.quest, notNilValue());
    assertThatBool(anotherKnight.hasHorseWillTravel, equalToBool(YES));
    assertThatFloat(anotherKnight.hitRatio, equalToFloat(13.75));

    CavalryMan* yetAnotherKnight = [_componentFactory componentForKey:@"yetAnotherKnight"];
    NSLog(@"Here's yet another knight: %@", yetAnotherKnight);
    assertThat(yetAnotherKnight.quest, notNilValue());
    assertThatBool(yetAnotherKnight.hasHorseWillTravel, equalToBool(YES));
    assertThatFloat(yetAnotherKnight.hitRatio, equalToFloat(13.75));
}

- (void)test_injects_type_converted_array_collection
{
    Knight* knight = [_componentFactory componentForKey:@"knightWithCollections"];
    NSArray* favoriteDamsels = [knight favoriteDamsels];
    assertThat(favoriteDamsels, notNilValue());
    assertThat(favoriteDamsels, hasCountOf(2));
    NSLog(@"Favorite damsels: %@", favoriteDamsels);
}

- (void)test_injects_collection_of_referenced_components_into_set
{
    Knight* knight = [_componentFactory componentForKey:@"knightWithCollections"];
    NSSet* friends = [knight friends];
    assertThat(friends, notNilValue());
    assertThat(friends, hasCountOf(2));
    NSLog(@"Friends: %@", friends);
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

/* ====================================================================================================================================== */
#pragma mark - Circular dependencies.

- (void)test_resolves_circular_dependencies_for_property_injected_by_reference
{
    ClassADependsOnB* classA = [_circularDependenciesFactory componentForKey:@"classA"];
    NSLog(@"Dependency on B: %@", classA.dependencyOnB);
    assertThat(classA.dependencyOnB, notNilValue());
    assertThat(classA, equalTo(classA.dependencyOnB.dependencyOnA));
    assertThat([classA.dependencyOnB class], equalTo([ClassBDependsOnA class]));

    ClassBDependsOnA* classB = [_circularDependenciesFactory componentForKey:@"classB"];
    NSLog(@"Dependency on A: %@", classB.dependencyOnA);
    assertThat(classB.dependencyOnA, notNilValue());
    assertThat(classB, equalTo(classB.dependencyOnA.dependencyOnB));
    assertThat([classB.dependencyOnA class], equalTo([ClassADependsOnB class]));

}

- (void)test_resolves_circular_dependencies_for_property_injected_by_type
{
    ClassADependsOnB* classA = [_circularDependenciesFactory componentForType:[ClassADependsOnB class]];
    NSLog(@"Dependency on B: %@", classA.dependencyOnB);
    assertThat(classA.dependencyOnB, notNilValue());
    assertThat(classA, equalTo(classA.dependencyOnB.dependencyOnA));
    assertThat([classA.dependencyOnB class], equalTo([ClassBDependsOnA class]));

    ClassBDependsOnA* classB = [_circularDependenciesFactory componentForType:[ClassBDependsOnA class]];
    NSLog(@"Dependency on A: %@", classB.dependencyOnA);
    assertThat(classB.dependencyOnA, notNilValue());
    assertThat(classB, equalTo(classB.dependencyOnA.dependencyOnB));
    assertThat([classB.dependencyOnA class], equalTo([ClassADependsOnB class]));
}

- (void)test_resolves_two_circular_dependencies_for_property_injected_by_reference
{
    ClassCDependsOnDAndE* classC = [_circularDependenciesFactory componentForKey:@"classC"];
    assertThat(classC.dependencyOnD, notNilValue());
    assertThat(classC.dependencyOnE, notNilValue());
    assertThat(classC, equalTo(classC.dependencyOnD.dependencyOnC));
    assertThat(classC, equalTo(classC.dependencyOnE.dependencyOnC));
    assertThat([classC.dependencyOnD class], equalTo([ClassDDependsOnC class]));
    assertThat([classC.dependencyOnE class], equalTo([ClassEDependsOnC class]));

    ClassDDependsOnC* classD = [_circularDependenciesFactory componentForKey:@"classD"];
    assertThat(classD.dependencyOnC, notNilValue());
    assertThat(classD, equalTo(classD.dependencyOnC.dependencyOnD));
    assertThat([classD.dependencyOnC class], equalTo([ClassCDependsOnDAndE class]));
}

/* ====================================================================================================================================== */
#pragma mark - Circular dependencies on singleton chains

- (void)test_resolves_chains_of_circular_dependencies_of_singletons_injected_by_type
{
	SingletonB *singletonB = [_singletonsChainFactory componentForType:[SingletonB class]];
	SingletonC *singletonC = [_singletonsChainFactory componentForType:[SingletonC class]];
	SingletonD *singletonD = [_singletonsChainFactory componentForType:[SingletonD class]];
	assertThat(singletonB.dependencyOnC, is(singletonC));
	assertThat(singletonC.dependencyOnD, is(singletonD));
	// Next assert consistently fails with xml assembly, and could fail with block assembly
	// depending on the order in which singletons are assembled during load (can be forced
	// to fail just by sorting _registry alphabetically in load method).
	assertThat(singletonD.dependencyOnB, is(singletonB));
}

- (void)test_resolves_chains_of_circular_dependencies_of_singletons_injected_by_reference
{
	SingletonB *singletonB = [_singletonsChainFactory componentForKey:@"singletonB"];
	SingletonC *singletonC = [_singletonsChainFactory componentForKey:@"singletonC"];
	SingletonD *singletonD = [_singletonsChainFactory componentForKey:@"singletonD"];
	assertThat(singletonB.dependencyOnC, is(singletonC));
	assertThat(singletonC.dependencyOnD, is(singletonD));
	// Next assert consistently fails with xml assembly, and could fail with block assembly
	// depending on the order in which singletons are assembled during load (can be forced
	// to fail just by sorting _registry alphabetically in load method).
	assertThat(singletonD.dependencyOnB, is(singletonB));
}



@end
