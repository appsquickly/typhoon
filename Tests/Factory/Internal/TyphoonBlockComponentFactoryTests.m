#import "SingletonB.h"////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import "TyphoonComponentFactory.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "MiddleAgesAssembly.h"
#import "TyphoonBundleResource.h"
#import "TyphoonConfigPostProcessor.h"
#import "ExceptionTestAssembly.h"
#import "Knight.h"
#import "CircularDependenciesAssembly.h"
#import "SingletonsChainAssembly.h"
#import "CavalryMan.h"
#import "InfrastructureComponentsAssembly.h"
#import "TyphoonTypeConverter.h"
#import "OCLogTemplate.h"
#import "Sword.h"
#import "TyphoonConfigAssembly.h"
#import "SingletonA.h"
#import "NotSingletonA.h"
#import "PrototypeInitInjected.h"
#import "PrototypePropertyInjected.h"
#import "ConfigAssembly.h"

@interface TyphoonBlockComponentFactoryTests : XCTestCase
{
    TyphoonComponentFactory *_componentFactory;
    TyphoonComponentFactory *_exceptionTestFactory;
    TyphoonComponentFactory *_circularDependenciesFactory;
    TyphoonComponentFactory *_singletonsChainFactory;
    TyphoonComponentFactory *_infrastructureComponentsFactory;
}

@end

@implementation TyphoonBlockComponentFactoryTests
{
    NSUInteger internalProcessorsCount;
}

- (void)setUp
{

    _componentFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[MiddleAgesAssembly assembly]];

    internalProcessorsCount = [[_componentFactory definitionPostProcessors] count];

    TyphoonConfigPostProcessor *processor = [TyphoonConfigPostProcessor forResourceNamed:@"SomeProperties.properties"];
    [_componentFactory attachPostProcessor:processor];

    _exceptionTestFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[ExceptionTestAssembly assembly]];
    _circularDependenciesFactory = [[TyphoonBlockComponentFactory alloc]
        initWithAssembly:[CircularDependenciesAssembly assembly]];
    _singletonsChainFactory = [[TyphoonBlockComponentFactory alloc]
        initWithAssembly:[SingletonsChainAssembly assembly]];
    _infrastructureComponentsFactory = [[TyphoonBlockComponentFactory alloc]
        initWithAssembly:[InfrastructureComponentsAssembly assembly]];
}

- (void)tearDown
{
    // Unregister NSNull converter picked up in infrastructure components assembly.
    // Try/catch to make the correct test fail if converterFor: throws an exception because of missing converter.
    @try {
        id<TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSNull"];
        [[TyphoonTypeConverterRegistry shared] unregisterTypeConverter:converter];
    }
    @catch (NSException *exception) {}
}

//-------------------------------------------------------------------------------------------
#pragma mark - Property Injection

- (void)test_injects_properties_by_reference_and_by_value
{
    Knight *knight = [_componentFactory componentForKey:@"knight"];

    XCTAssertNotNil(knight);
    XCTAssertNotNil(knight.quest);
    XCTAssertEqualObjects([knight.quest questName], @"Campaign Quest");
    XCTAssertEqual(knight.damselsRescued, 12);
}

- (void)test_mixed_initializer_and_property_injection
{
    CavalryMan *anotherKnight = [_componentFactory componentForKey:@"anotherKnight"];
    XCTAssertNotNil(anotherKnight.quest);
    XCTAssertEqual(anotherKnight.hasHorseWillTravel, YES);
    XCTAssertEqual(anotherKnight.hitRatio, 13.75);

    CavalryMan *yetAnotherKnight = [_componentFactory componentForKey:@"yetAnotherKnight"];
    XCTAssertNotNil(yetAnotherKnight.quest);
    XCTAssertEqual(yetAnotherKnight.hasHorseWillTravel, YES);
    XCTAssertEqual(yetAnotherKnight.hitRatio, 13.75);
}

- (void)test_injects_type_converted_array_collection
{
    Knight *knight = [_componentFactory componentForKey:@"knightWithCollections"];
    NSArray *favoriteDamsels = [knight favoriteDamsels];
    XCTAssertNotNil(favoriteDamsels);
    XCTAssertEqual([favoriteDamsels count], 2);
}

- (void)test_injection_with_dictionary
{
    if ([_componentFactory isKindOfClass:[TyphoonBlockComponentFactory class]]) {

        Knight *knight = [_componentFactory componentForKey:@"knightWithCollections"];

        XCTAssertNotNil(knight.friendsDictionary);
        XCTAssertTrue([knight.friendsDictionary count] == 2);
        XCTAssertTrue([[knight.friendsDictionary[@"knight"] class] isSubclassOfClass:[Knight class]]);
        XCTAssertTrue([[knight.friendsDictionary[@"anotherKnight"] class] isSubclassOfClass:[CavalryMan class]]);
    }
}

- (void)test_injects_collection_of_referenced_components_into_set
{
    Knight *knight = [_componentFactory componentForKey:@"knightWithCollections"];
    NSSet *friends = [knight friends];
    XCTAssertNotNil(friends);
    XCTAssertTrue([friends count] == 2);
}

- (void)test_allows_injecting_properties_with_object_instance
{
    MiddleAgesAssembly *assembly = (MiddleAgesAssembly *)_componentFactory;
    CavalryMan *knight = [assembly yetAnotherKnight];
    XCTAssertNotNil(knight.propertyInjectedAsInstance);

    LogTrace(@"%@", knight.propertyInjectedAsInstance);
}

- (void)test_method_injection
{
    Knight *knight = [(MiddleAgesAssembly *)_componentFactory knightWithMethodInjection];

    XCTAssertNotNil(knight.quest);
    XCTAssertEqual(knight.damselsRescued, 321);

}

- (void)test_fake_property_injection
{
    Knight *knight = [(MiddleAgesAssembly *)_componentFactory knightWithFakePropertyQuest];

    XCTAssertNotNil(knight.favoriteQuest);
}

- (void)test_fake_property_injection_by_type
{
    XCTAssertThrows([(MiddleAgesAssembly *)_componentFactory knightWithFakePropertyQuestByType]);
}

//-------------------------------------------------------------------------------------------
#pragma mark Class Method Initializer

- (void)test_class_method_injection
{
    NSURL *url = [_componentFactory componentForKey:@"serviceUrl"];
    XCTAssertNotNil(url);
}

- (void)test_class_method_injection_raises_exception_if_required_class_not_set
{
    @try {
        NSURL *url = [_exceptionTestFactory componentForKey:@"anotherServiceUrl"];
        if (![url isEqual:[NSURL URLWithString:@"http://dev.foobar.com/service/"]]) {
            XCTFail(@"Should have thrown exception");
        }
        url = nil;
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description],
            @"Unless the type is primitive (int, BOOL, etc), initializer injection requires the required"
                " class to be specified. Eg: <argument parameterName=\"string\" value=\"http://dev.foobar.com/service/\" required-class=\"NSString\" />");
    }

}

#pragma mark Factory Initializer

- (void)test_returns_component_from_factory_component
{
    Sword *sword = [_componentFactory componentForKey:@"blueSword"];
    XCTAssertEqualObjects([sword description], @"A bright blue sword with orange pom-poms at the hilt.");
}

//-------------------------------------------------------------------------------------------
#pragma mark initializer injection

- (void)test_injects_collection_in_initializer
{
    Knight *knight = [_componentFactory componentForKey:@"knightWithCollectionInConstructor"];
    NSArray *favoriteDamsels = [knight favoriteDamsels];
    XCTAssertNotNil(favoriteDamsels);
    XCTAssertTrue([favoriteDamsels count] == 2);
}


//-------------------------------------------------------------------------------------------
#pragma mark Property-based configuration

- (void)test_resolves_property_values
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc]
        initWithAssembly:[TyphoonConfigAssembly assembly]];
    TyphoonConfigPostProcessor *processor = [TyphoonConfigPostProcessor forResourceNamed:@"SomeProperties.properties"];
    [factory attachPostProcessor:processor];

    Knight *knight = [factory componentForKey:@"knight"];
    XCTAssertEqual(knight.damselsRescued, 12);

    CavalryMan *anotherKnight = [factory componentForKey:@"anotherKnight"];
    XCTAssertEqual(anotherKnight.hasHorseWillTravel, NO);

}

#pragma mark - Infrastructure definitions

- (void)test_post_processor_component_recognized
{

    XCTAssertEqual([_infrastructureComponentsFactory.definitionPostProcessors count],
        1 + internalProcessorsCount); //Attached + internal processors
}

- (void)test_resolves_property_values_from_multiple_files
{
    Knight *knight = [_infrastructureComponentsFactory componentForKey:@"knight"];
    XCTAssertTrue(knight.hasHorseWillTravel);
    XCTAssertEqual(knight.damselsRescued, 12);
}

- (void)test_type_converter_recognized
{
    id<TyphoonTypeConverter> nullConverter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSNull"];
    XCTAssertNotNil(nullConverter);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Circular dependencies.

- (void)test_resolves_circular_dependencies_for_property_injected_by_reference
{
    if ([_circularDependenciesFactory isKindOfClass:[TyphoonBlockComponentFactory class]]) {
        ClassADependsOnB *classA = [_circularDependenciesFactory componentForKey:@"classA"];
        XCTAssertNotNil(classA.dependencyOnB);
        XCTAssertEqual(classA, classA.dependencyOnB.dependencyOnA);
        XCTAssertEqual([classA.dependencyOnB class], [ClassBDependsOnA class]);

        ClassBDependsOnA *classB = [_circularDependenciesFactory componentForKey:@"classB"];
        XCTAssertNotNil(classB.dependencyOnA);
        XCTAssertEqual(classB, classB.dependencyOnA.dependencyOnB);
        XCTAssertEqual([classB.dependencyOnA class], [ClassADependsOnB class]);
    }
}

- (void)test_resolves_circular_dependencies_for_property_injected_by_type
{
    if ([_circularDependenciesFactory isKindOfClass:[TyphoonBlockComponentFactory class]]) {
        ClassADependsOnB *classA = [_circularDependenciesFactory componentForType:[ClassADependsOnB class]];
        XCTAssertNotNil(classA.dependencyOnB);
        XCTAssertEqual(classA, classA.dependencyOnB.dependencyOnA);
        XCTAssertEqual([classA.dependencyOnB class], [ClassBDependsOnA class]);

        ClassBDependsOnA *classB = [_circularDependenciesFactory componentForType:[ClassBDependsOnA class]];
        XCTAssertNotNil(classB.dependencyOnA);
        XCTAssertEqual(classB, classB.dependencyOnA.dependencyOnB);
        XCTAssertEqual([classB.dependencyOnA class], [ClassADependsOnB class]);
    }
}

- (void)test_resolves_two_circular_dependencies_for_property_injected_by_reference
{
    ClassCDependsOnDAndE *classC = [_circularDependenciesFactory componentForKey:@"classC"];
    XCTAssertNotNil(classC.dependencyOnD);
    XCTAssertNotNil(classC.dependencyOnE);
    XCTAssertEqual(classC, classC.dependencyOnD.dependencyOnC);
    XCTAssertEqual(classC, classC.dependencyOnE.dependencyOnC);
    XCTAssertEqual([classC.dependencyOnD class], [ClassDDependsOnC class]);
    XCTAssertEqual([classC.dependencyOnE class], [ClassEDependsOnC class]);

    ClassDDependsOnC *classD = [_circularDependenciesFactory componentForKey:@"classD"];
    XCTAssertNotNil(classD.dependencyOnC);
    XCTAssertEqual(classD, classD.dependencyOnC.dependencyOnD);
    XCTAssertEqual([classD.dependencyOnC class], [ClassCDependsOnDAndE class]);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Circular dependencies on singleton chains

- (void)test_resolves_chains_of_circular_dependencies_of_singletons_injected_by_type
{
    SingletonA *singletonADependsOnBViaProperty = [_singletonsChainFactory componentForType:[SingletonA class]];
    SingletonB *singletonBDependsOnNotSingletonAViaProperty = [_singletonsChainFactory componentForType:[SingletonB class]];
    NotSingletonA *notSingletonADependsOnAViaInitializer = [_singletonsChainFactory componentForType:[NotSingletonA class]];
    XCTAssertEqual(singletonADependsOnBViaProperty.dependencyOnB, singletonBDependsOnNotSingletonAViaProperty);
    XCTAssertEqual(singletonBDependsOnNotSingletonAViaProperty.dependencyOnNotSingletonA.dependencyOnA,
        singletonADependsOnBViaProperty);
    XCTAssertEqual(notSingletonADependsOnAViaInitializer.dependencyOnA, singletonADependsOnBViaProperty);
}

- (void)test_resolves_chains_of_circular_dependencies_of_singletons_injected_by_reference
{
    SingletonA *singletonA = [_singletonsChainFactory componentForKey:@"singletonA"];
    SingletonB *singletonB = [_singletonsChainFactory componentForKey:@"singletonB"];
    NotSingletonA *notSingletonA = [_singletonsChainFactory componentForKey:@"notSingletonA"];
    XCTAssertEqual(singletonA.dependencyOnB, singletonB);
    XCTAssertEqual(singletonB.dependencyOnNotSingletonA.dependencyOnA, singletonA);
    XCTAssertEqual(notSingletonA.dependencyOnA, singletonA);
}

- (void)test_initializer_injected_component_is_correctly_resolved_in_circular_dependency
{
    PrototypeInitInjected *initializerInjected = [_circularDependenciesFactory componentForType:[PrototypeInitInjected class]];
    PrototypePropertyInjected *propertyInjected = [_circularDependenciesFactory componentForType:[PrototypePropertyInjected class]];
    // should be expected class, but not same instance
    XCTAssertTrue([initializerInjected.prototypePropertyInjected isKindOfClass:[PrototypePropertyInjected class]]);
    XCTAssertNotEqual(initializerInjected.prototypePropertyInjected, propertyInjected);
    XCTAssertTrue([propertyInjected.prototypeInitInjected isKindOfClass:[PrototypeInitInjected class]]);
    XCTAssertNotEqual(propertyInjected.prototypeInitInjected, initializerInjected);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Currently Resolving Overwriting Problem

- (void)
test_currently_resolving_references_dictionary_is_not_overwritten_when_initializing_two_instances_of_prototype_in_the_same_chain
{
    CROSingletonA *singletonA = [_circularDependenciesFactory componentForType:[CROSingletonA class]];
    XCTAssertNotNil(singletonA.prototypeB);
    XCTAssertNotNil(singletonA.prototypeA);
}


- (void)test_exception_when_initializer_dependency_chain
{
    @try {
        [_circularDependenciesFactory componentForKey:@"incorrectPrototypeB"];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *exception) {
        XCTAssertEqualObjects([exception name], @"CircularInitializerDependence");
    }
}

- (void)test_resolves_component_using_selector
{
    MiddleAgesAssembly *assembly = (MiddleAgesAssembly *)_componentFactory;
    Knight *knight = [assembly knight];
    XCTAssertNotNil(knight);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Configuration

- (void)test_returns_instance_configured_from_typhoon_config
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc]
        initWithAssemblies:@[[ConfigAssembly assembly]]];
    Knight *knight = [(ConfigAssembly *)factory configuredCavalryMan];
    XCTAssertNotNil(knight);
    XCTAssertEqual(knight.damselsRescued, (NSUInteger)3);
}

@end

