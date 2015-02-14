////////////////////////////////////////////////////////////////////////////////
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
#import "Typhoon.h"
#import "Knight.h"
#import "CampaignQuest.h"

NSUInteger currentDamselsRescued;
BOOL currentHasHorseWillTravel;
NSString *currentFooString;


@interface ClassWithKnightSettings : NSObject
@property(nonatomic) NSUInteger damselsRescued;
@property(nonatomic) BOOL hasHorseWillTravel;
@property(nonatomic) NSString *fooString;
@end

@implementation ClassWithKnightSettings
@end

@interface ClassWithKnightSettingsAssembly : TyphoonAssembly
@end

@implementation ClassWithKnightSettingsAssembly

- (id)knightSettings
{
    return [TyphoonDefinition withClass:[ClassWithKnightSettings class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(currentDamselsRescued)];
        [definition injectProperty:@selector(hasHorseWillTravel) with:@(currentHasHorseWillTravel)];
        [definition injectProperty:@selector(fooString) with:currentFooString];
    }];
}

@end


@interface FactoryReferenceInjectionsTests : XCTestCase

@end


@implementation FactoryReferenceInjectionsTests
{
    TyphoonComponentFactory *factory;
}

- (void)setUp
{
    [self updateFactory];
}

- (void)updateFactory
{
    factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ClassWithKnightSettingsAssembly assembly]];
}

- (void)test_inject_int_bool
{
    Knight *knight = [Knight new];

    TyphoonDefinition *knightDefinition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(30)];
        [definition injectProperty:@selector(hasHorseWillTravel) with:@(YES)];
    }];

    [factory doInjectionEventsOn:(id) knight withDefinition:knightDefinition args:nil];

    XCTAssertEqual(knight.damselsRescued, 30);
    XCTAssertEqual(knight.hasHorseWillTravel, YES);
}

- (void)test_inject_object
{
    Knight *knight = [Knight new];

    NSString *testString = @"Hello Knights";

    TyphoonDefinition *knightDefinition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:testString];
    }];
    [factory doInjectionEventsOn:(id) knight withDefinition:knightDefinition args:nil];

    XCTAssertEqual(knight.foobar, [testString copy]);
}

- (void)test_inject_factorydefinition_selector
{
    Knight *knight = [Knight new];

    currentFooString = @"Hello Knights";
    currentDamselsRescued = 24;
    currentHasHorseWillTravel = YES;
    [self updateFactory];

    TyphoonDefinition *settings = [factory definitionForType:[ClassWithKnightSettings class]];

    TyphoonDefinition *knightDefinition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:[settings property:@selector(damselsRescued)]];
        [definition injectProperty:@selector(hasHorseWillTravel) with:[settings property:@selector(hasHorseWillTravel)]];
        [definition injectProperty:@selector(foobar) with:[settings property:@selector(fooString)]];
    }];
    [factory doInjectionEventsOn:(id) knight withDefinition:knightDefinition args:nil];

    XCTAssertEqual(knight.foobar, @"Hello Knights");
    XCTAssertEqual(knight.damselsRescued, 24);
    XCTAssertEqual(knight.hasHorseWillTravel, YES);
}

- (void)test_inject_factorydefinition_keyPath
{
    Knight *knight = [Knight new];

    NSString *testString = @"Hello";
    currentFooString = [testString copy];
    [self updateFactory];

    TyphoonDefinition *settings = [factory definitionForType:[ClassWithKnightSettings class]];

    TyphoonDefinition *knightDefinition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:[settings keyPath:@"fooString.uppercaseString"]];
    }];
    [factory doInjectionEventsOn:(id) knight withDefinition:knightDefinition args:nil];

    XCTAssertEqualObjects(knight.foobar, @"HELLO");
}


- (void)test_inject_factorydefinition_on_init
{
    currentDamselsRescued = 32;
    currentFooString = @"Hello";
    [self updateFactory];

    TyphoonDefinition *settings = [factory definitionForType:[ClassWithKnightSettings class]];

    TyphoonDefinition *knightDefinition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDamselsRescued:foo:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[settings property:@selector(damselsRescued)]];
            [initializer injectParameterWith:[settings keyPath:@"fooString.uppercaseString"]];
        }];
    }];

    [factory registerDefinition:knightDefinition];

    Knight *knight = [factory componentForType:[Knight class]];

    XCTAssertEqual(knight.damselsRescued, 32);
    XCTAssertEqualObjects(knight.foobar, @"HELLO");

}

- (void)test_injection_readonly_properties
{
    TyphoonDefinition *quest = [TyphoonDefinition withClass:[CampaignQuest class]];
    
    TyphoonDefinition *knightDefinition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(readOnlyQuest)];
    }];
    [factory registerDefinition:quest];
    [factory registerDefinition:knightDefinition];
    
    XCTAssertThrows([factory componentForType:[Knight class]], @"Should throw exception, because property readonly");
}


@end
