#import "SingletonB.h"////////////////////////////////////////////////////////////////////////////////
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
#import "TyphoonBundleResource.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "ExceptionTestAssembly.h"
#import "Knight.h"
#import "CircularDependenciesAssembly.h"
#import "SingletonsChainAssembly.h"
#import "CavalryMan.h"
#import "InfrastructureComponentsAssembly.h"
#import "TyphoonTypeConverter.h"
#import "OCLogTemplate.h"
#import "Sword.h"
#import "PropertyPlaceholderAssembly.h"
#import "SingletonA.h"
#import "NotSingletonA.h"
#import "PrototypeInitInjected.h"
#import "PrototypePropertyInjected.h"

@interface TyphoonBlockComponentFactoryTests : SenTestCase {
    TyphoonComponentFactory *_componentFactory;
    TyphoonComponentFactory *_exceptionTestFactory;
    TyphoonComponentFactory *_circularDependenciesFactory;
    TyphoonComponentFactory *_singletonsChainFactory;
    TyphoonComponentFactory *_infrastructureComponentsFactory;
}

@end

@implementation TyphoonBlockComponentFactoryTests

- (void)setUp
{
    _componentFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[MiddleAgesAssembly assembly]];
    TyphoonPropertyPlaceholderConfigurer *configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachPostProcessor:configurer];

    _exceptionTestFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[ExceptionTestAssembly assembly]];
    _circularDependenciesFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[CircularDependenciesAssembly assembly]];
    _singletonsChainFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[SingletonsChainAssembly assembly]];
    _infrastructureComponentsFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[InfrastructureComponentsAssembly assembly]];
}

- (void)tearDown
{
    // Unregister NSNull converter picked up in infrastructure components assembly.
    // Try/catch to make the correct test fail if converterFor: throws an exception because of missing converter.
    @try {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSNull"];
        [[TyphoonTypeConverterRegistry shared] unregisterTypeConverter:converter];
    }
    @catch (NSException *exception) {}
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)test_injects_properties_by_reference_and_by_value
{
    Knight *knight = [_componentFactory componentForKey:@"knight"];

    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    assertThat([knight.quest questName], equalTo(@"Campaign Quest"));
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));
}

- (void)test_mixed_initializer_and_property_injection
{
    CavalryMan *anotherKnight = [_componentFactory componentForKey:@"anotherKnight"];
    assertThat(anotherKnight.quest, notNilValue());
    assertThatBool(anotherKnight.hasHorseWillTravel, equalToBool(YES));
    assertThatFloat(anotherKnight.hitRatio, equalToFloat(13.75));

    CavalryMan *yetAnotherKnight = [_componentFactory componentForKey:@"yetAnotherKnight"];
    assertThat(yetAnotherKnight.quest, notNilValue());
    assertThatBool(yetAnotherKnight.hasHorseWillTravel, equalToBool(YES));
    assertThatFloat(yetAnotherKnight.hitRatio, equalToFloat(13.75));
}

- (void)test_injects_type_converted_array_collection
{
    Knight *knight = [_componentFactory componentForKey:@"knightWithCollections"];
    NSArray *favoriteDamsels = [knight favoriteDamsels];
    assertThat(favoriteDamsels, notNilValue());
    assertThat(favoriteDamsels, hasCountOf(2));
}

- (void)test_injection_with_dictionary
{
    if ([_componentFactory isKindOfClass:[TyphoonBlockComponentFactory class]]) {

        Knight *knight = [_componentFactory componentForKey:@"knightWithCollections"];

        assertThat(knight.friendsDictionary, notNilValue());
        assertThat(knight.friendsDictionary, hasCountOf(2));
        STAssertTrue([[knight.friendsDictionary[@"knight"] class] isSubclassOfClass:[Knight class]], nil);
        STAssertTrue([[knight.friendsDictionary[@"anotherKnight"] class] isSubclassOfClass:[CavalryMan class]], nil);
    }
}

- (void)test_injects_collection_of_referenced_components_into_set
{
    Knight *knight = [_componentFactory componentForKey:@"knightWithCollections"];
    NSSet *friends = [knight friends];
    assertThat(friends, notNilValue());
    assertThat(friends, hasCountOf(2));
}

- (void)test_allows_injecting_properties_with_object_instance
{
    MiddleAgesAssembly *assembly = (MiddleAgesAssembly *) _componentFactory;
    CavalryMan *knight = [assembly yetAnotherKnight];
    assertThat(knight.propertyInjectedAsInstance, notNilValue());

    LogTrace(@"%@", knight.propertyInjectedAsInstance);
}

- (void)test_method_injection
{
    Knight *knight = [(MiddleAgesAssembly *)_componentFactory knightWithMethodInjection];

    assertThat(knight.quest, notNilValue());
    assertThatUnsignedInteger(knight.damselsRescued, equalToUnsignedInteger(321));

}

/* ====================================================================================================================================== */
#pragma mark Class Method Initializer
- (void)test_class_method_injection
{
    NSURL *url = [_componentFactory componentForKey:@"serviceUrl"];
    assertThat(url, isNot(nilValue()));
}

- (void)test_class_method_injection_raises_exception_if_required_class_not_set
{
    @try {
        NSURL *url = [_exceptionTestFactory componentForKey:@"anotherServiceUrl"];
        if (![url isEqual:[NSURL URLWithString:@"http://dev.foobar.com/service/"]]) {
            STFail(@"Should have thrown exception");
        }
        url = nil;
    }
    @catch (NSException *e) {
        assertThat([e description], equalTo(@"Unless the type is primitive (int, BOOL, etc), initializer injection requires the required class to be specified. Eg: <argument parameterName=\"string\" value=\"http://dev.foobar.com/service/\" required-class=\"NSString\" />"));
    }

}

#pragma mark Factory Initializer
- (void)test_returns_component_from_factory_component
{
    Sword *sword = [_componentFactory componentForKey:@"blueSword"];
    assertThat([sword description], equalTo(@"A bright blue sword with orange pom-poms at the hilt."));
}

/* ====================================================================================================================================== */
#pragma mark initializer injection

- (void)test_injects_collection_in_initializer
{
    Knight *knight = [_componentFactory componentForKey:@"knightWithCollectionInConstructor"];
    NSArray *favoriteDamsels = [knight favoriteDamsels];
    assertThat(favoriteDamsels, notNilValue());
    assertThat(favoriteDamsels, hasCountOf(2));
}


/* ====================================================================================================================================== */
#pragma mark Property-based configuration

- (void)test_resolves_property_values
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[PropertyPlaceholderAssembly assembly]];
    TyphoonPropertyPlaceholderConfigurer *configurer = [TyphoonPropertyPlaceholderConfigurer configurer];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [factory attachPostProcessor:configurer];

    Knight *knight = [factory componentForKey:@"knight"];
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));

    CavalryMan *anotherKnight = [factory componentForKey:@"anotherKnight"];
    assertThatBool(anotherKnight.hasHorseWillTravel, equalToBool(NO));

}

#pragma mark - Infrastructure definitions

- (void)test_post_processor_component_recognized
{
    NSUInteger internalProcessors = 2;
    if ([_infrastructureComponentsFactory isKindOfClass:[TyphoonBlockComponentFactory class]]) {
        internalProcessors += 1;
    }assertThatUnsignedLong([_infrastructureComponentsFactory.factoryPostProcessors count], equalToInt(
        1 + internalProcessors)); //Attached + internal processors
}

- (void)test_resolves_property_values_from_multiple_files
{
    Knight *knight = [_infrastructureComponentsFactory componentForKey:@"knight"];
    assertThatBool(knight.hasHorseWillTravel, equalToBool(YES));
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));
}

- (void)test_type_converter_recognized
{
    id <TyphoonTypeConverter> nullConverter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSNull"];
    assertThat(nullConverter, notNilValue());
}

/* ====================================================================================================================================== */
#pragma mark - Circular dependencies.

- (void)test_resolves_circular_dependencies_for_property_injected_by_reference
{
    if ([_circularDependenciesFactory isKindOfClass:[TyphoonBlockComponentFactory class]]) {
        ClassADependsOnB *classA = [_circularDependenciesFactory componentForKey:@"classA"];
        assertThat(classA.dependencyOnB, notNilValue());
        assertThat(classA, equalTo(classA.dependencyOnB.dependencyOnA));
        assertThat([classA.dependencyOnB class], equalTo([ClassBDependsOnA class]));

        ClassBDependsOnA *classB = [_circularDependenciesFactory componentForKey:@"classB"];
        assertThat(classB.dependencyOnA, notNilValue());
        assertThat(classB, equalTo(classB.dependencyOnA.dependencyOnB));
        assertThat([classB.dependencyOnA class], equalTo([ClassADependsOnB class]));
    }
}

- (void)test_resolves_circular_dependencies_for_property_injected_by_type
{
    if ([_circularDependenciesFactory isKindOfClass:[TyphoonBlockComponentFactory class]]) {
        ClassADependsOnB *classA = [_circularDependenciesFactory componentForType:[ClassADependsOnB class]];
        assertThat(classA.dependencyOnB, notNilValue());
        assertThat(classA, equalTo(classA.dependencyOnB.dependencyOnA));
        assertThat([classA.dependencyOnB class], equalTo([ClassBDependsOnA class]));

        ClassBDependsOnA *classB = [_circularDependenciesFactory componentForType:[ClassBDependsOnA class]];
        assertThat(classB.dependencyOnA, notNilValue());
        assertThat(classB, equalTo(classB.dependencyOnA.dependencyOnB));
        assertThat([classB.dependencyOnA class], equalTo([ClassADependsOnB class]));
    }
}

- (void)test_resolves_two_circular_dependencies_for_property_injected_by_reference
{
    ClassCDependsOnDAndE *classC = [_circularDependenciesFactory componentForKey:@"classC"];
    assertThat(classC.dependencyOnD, notNilValue());
    assertThat(classC.dependencyOnE, notNilValue());
    assertThat(classC, equalTo(classC.dependencyOnD.dependencyOnC));
    assertThat(classC, equalTo(classC.dependencyOnE.dependencyOnC));
    assertThat([classC.dependencyOnD class], equalTo([ClassDDependsOnC class]));
    assertThat([classC.dependencyOnE class], equalTo([ClassEDependsOnC class]));

    ClassDDependsOnC *classD = [_circularDependenciesFactory componentForKey:@"classD"];
    assertThat(classD.dependencyOnC, notNilValue());
    assertThat(classD, equalTo(classD.dependencyOnC.dependencyOnD));
    assertThat([classD.dependencyOnC class], equalTo([ClassCDependsOnDAndE class]));
}

/* ====================================================================================================================================== */
#pragma mark - Circular dependencies on singleton chains
- (void)test_resolves_chains_of_circular_dependencies_of_singletons_injected_by_type
{
    SingletonA *singletonADependsOnBViaProperty = [_singletonsChainFactory componentForType:[SingletonA class]];
    SingletonB *singletonBDependsOnNotSingletonAViaProperty = [_singletonsChainFactory componentForType:[SingletonB class]];
    NotSingletonA *notSingletonADependsOnAViaInitializer = [_singletonsChainFactory componentForType:[NotSingletonA class]];
    assertThat(singletonADependsOnBViaProperty.dependencyOnB, is(singletonBDependsOnNotSingletonAViaProperty));
    assertThat(singletonBDependsOnNotSingletonAViaProperty.dependencyOnNotSingletonA.dependencyOnA, is(singletonADependsOnBViaProperty));
    assertThat(notSingletonADependsOnAViaInitializer.dependencyOnA, is(singletonADependsOnBViaProperty));
}

- (void)test_resolves_chains_of_circular_dependencies_of_singletons_injected_by_reference
{
    SingletonA *singletonA = [_singletonsChainFactory componentForKey:@"singletonA"];
    SingletonB *singletonB = [_singletonsChainFactory componentForKey:@"singletonB"];
    NotSingletonA *notSingletonA = [_singletonsChainFactory componentForKey:@"notSingletonA"];
    assertThat(singletonA.dependencyOnB, is(singletonB));
    assertThat(singletonB.dependencyOnNotSingletonA.dependencyOnA, is(singletonA));
    assertThat(notSingletonA.dependencyOnA, is(singletonA));
}

- (void)test_initializer_injected_component_is_correctly_resolved_in_circular_dependency
{
    PrototypeInitInjected *initializerInjected = [_circularDependenciesFactory componentForType:[PrototypeInitInjected class]];
    PrototypePropertyInjected *propertyInjected = [_circularDependenciesFactory componentForType:[PrototypePropertyInjected class]];
    // should be expected class, but not same instance
    assertThat(initializerInjected.prototypePropertyInjected, instanceOf([PrototypePropertyInjected class]));
    assertThat(initializerInjected.prototypePropertyInjected, isNot(propertyInjected));
    assertThat(propertyInjected.prototypeInitInjected, instanceOf([PrototypeInitInjected class]));
    assertThat(propertyInjected.prototypeInitInjected, isNot(initializerInjected));
}

/* ====================================================================================================================================== */
#pragma mark - Currently Resolving Overwriting Problem
- (void)test_currently_resolving_references_dictionary_is_not_overwritten_when_initializing_two_instances_of_prototype_in_the_same_chain
{
    CROSingletonA *singletonA = [_circularDependenciesFactory componentForType:[CROSingletonA class]];
    assertThat(singletonA.prototypeB, isNot(nilValue()));
    assertThat(singletonA.prototypeA, isNot(nilValue()));
}


- (void)test_exception_when_initializer_dependency_chain
{
    @try {
        [_circularDependenciesFactory componentForKey:@"incorrectPrototypeB"];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException *exception) {
        assertThat([exception name], equalTo(@"CircularInitializerDependence"));
    }
}

- (void)test_resolves_component_using_selector
{
    MiddleAgesAssembly *assembly = (MiddleAgesAssembly *) _componentFactory;
    Knight *knight = [assembly knight];
    assertThat(knight, notNilValue());
}

@end

