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
#import "OCLogTemplate.h"
#import "TyphoonTestAssemblyConfigPostProcessor.h"

@interface TyphoonConfigPostProcessorTests : XCTestCase
@end

@implementation TyphoonConfigPostProcessorTests
{
    TyphoonConfigPostProcessor *_configurer;
}

- (void)setUp
{
    _configurer = [TyphoonConfigPostProcessor processor];
    [_configurer useResourceWithName:@"SomeProperties.properties"];
    [_configurer useResourceWithName:@"SomeProperties.json"];
    [_configurer useResourceWithName:@"SomeProperties.plist"];

}

- (void)test_parses_property_name_value_pairs
{
    // TODO: replace with an actual automated test.
//    NSDictionary *properties = [_configurer properties];
//    LogTrace(@"Properties: %@", properties);
//    properties = nil;
}

- (void)test_mutates_initializer_values
{
    TyphoonComponentFactory *factory = [[TyphoonComponentFactory alloc] init];
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition useInitializer:@selector(initWithQuest:damselsRescued:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:nil];
        [initializer injectParameterWith:TyphoonConfig(@"damsels.rescued")];
    }];
    [factory registerDefinition:knightDefinition];

    [self postProcessFactory:factory withPostProcessor:_configurer];

    Knight *knight = [factory componentForType:[Knight class]];
    XCTAssertEqual(knight.damselsRescued, (NSUInteger)12);

}

- (void)test_mutates_property_values
{
    TyphoonComponentFactory *factory = [[TyphoonComponentFactory alloc] init];
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(damselsRescued) with:TyphoonConfig(@"damsels.rescued")];
    [factory registerDefinition:knightDefinition];

    [self postProcessFactory:factory withPostProcessor:_configurer];

    Knight *knight = [factory componentForType:[Knight class]];
    XCTAssertEqual(knight.damselsRescued, (NSUInteger)12);

}

- (void)test_json_values
{
    TyphoonComponentFactory *factory = [[TyphoonComponentFactory alloc] init];
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition useInitializer:@selector(initWithQuest:damselsRescued:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:nil];
        [initializer injectParameterWith:TyphoonConfig(@"json.damsels_rescued")];
    }];
    [knightDefinition injectProperty:@selector(hasHorseWillTravel) with:TyphoonConfig(@"json.hasHorseWillTravel")];
    [factory registerDefinition:knightDefinition];

    [self postProcessFactory:factory withPostProcessor:_configurer];

    Knight *knight = [factory componentForType:[Knight class]];
    XCTAssertEqual(knight.damselsRescued, (NSUInteger)42);
    XCTAssertEqual(knight.hasHorseWillTravel, (BOOL)YES);
}

- (void)test_plist_values
{
    TyphoonComponentFactory *factory = [[TyphoonComponentFactory alloc] init];
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition useInitializer:@selector(initWithQuest:damselsRescued:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:nil];
        [initializer injectParameterWith:TyphoonConfig(@"plist.damsels")];
    }];
    [knightDefinition injectProperty:@selector(hasHorseWillTravel) with:TyphoonConfig(@"plist.hasHorse")];
    [factory registerDefinition:knightDefinition];

    [self postProcessFactory:factory withPostProcessor:_configurer];

    Knight *knight = [factory componentForType:[Knight class]];
    XCTAssertEqual(knight.damselsRescued, (NSUInteger)28);
    XCTAssertEqual(knight.hasHorseWillTravel, (BOOL)YES);
}

- (void)test_config_as_runtime_argument
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc]
        initWithAssembly:[TyphoonTestAssemblyConfigPostProcessor assembly]];
    [self postProcessFactory:factory withPostProcessor:_configurer];
    Knight *knight = [factory componentForType:[Knight class]];
    XCTAssertEqualObjects(knight.quest.imageUrl, [NSURL URLWithString:@"http://google.com/"]);
}

- (void)test_injecting_with_concrete_namespace
{
    [_configurer registerNamespace:[TyphoonDefinitionNamespace namespaceWithKey:@"TyphoonTestAssemblyConfigPostProcessor"]];
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc]
                                        initWithAssembly:[TyphoonTestAssemblyConfigPostProcessor assembly]];
    [self postProcessFactory:factory withPostProcessor:_configurer];
    Knight *knight = [factory componentForType:[Knight class]];
    XCTAssertEqualObjects(knight.quest.imageUrl, [NSURL URLWithString:@"http://google.com/"]);
}

- (void)test_throws_exception_when_config_is_from_another_namespace
{
    [_configurer registerNamespace:[TyphoonDefinitionNamespace namespaceWithKey:@"OtherAssembly"]];
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc]
                                        initWithAssembly:[TyphoonTestAssemblyConfigPostProcessor assembly]];
    [self postProcessFactory:factory withPostProcessor:_configurer];
    XCTAssertThrows([factory componentForType:[Knight class]]);
}

- (void)test_choose_right_config_value
{
    TyphoonConfigPostProcessor *postProcessor1 = [TyphoonConfigPostProcessor forResourceNamed:@"PropertiesA.plist"];
    [postProcessor1 registerNamespace:[TyphoonDefinitionNamespace namespaceWithKey:@"TyphoonTestAssemblyConfigPostProcessor"]];
    TyphoonConfigPostProcessor *postProcessor2 = [TyphoonConfigPostProcessor forResourceNamed:@"PropertiesB.plist"];
    [postProcessor2 registerNamespace:[TyphoonDefinitionNamespace namespaceWithKey:@"OtherAssembly"]];
    
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc]
                                        initWithAssembly:[TyphoonTestAssemblyConfigPostProcessor assembly]];
    [self postProcessFactory:factory withPostProcessors:@[postProcessor1, postProcessor2]];
    Knight *knight = [(id)factory otherKnight];
    XCTAssertEqual(knight.damselsRescued, (unsigned long)23);
}

- (void)postProcessFactory:(TyphoonComponentFactory *)factory withPostProcessors:(NSArray *)postProcessors
{
    for (id<TyphoonDefinitionPostProcessor> postProcessor in postProcessors) {
        [self postProcessFactory:factory withPostProcessor:postProcessor];
    }
}

- (void)postProcessFactory:(TyphoonComponentFactory *)factory withPostProcessor:(id<TyphoonDefinitionPostProcessor>)postProcessor
{
    [factory enumerateDefinitions:^(TyphoonDefinition *definition, NSUInteger index, TyphoonDefinition **definitionToReplace, BOOL *stop) {
        [postProcessor postProcessDefinition:definition replacement:definitionToReplace withFactory:factory];
    }];
}

@end
