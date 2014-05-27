//
//  DefinitionConfigurationTest.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 22.05.14.
//
//

#import <XCTest/XCTest.h>
#import <XCTest/XCTest.h>
#import "AssemblyWithDefinitionConfiguration.h"
#import "TyphoonBlockComponentFactory.h"

@interface DefinitionConfigurationTest : XCTestCase

@end

@implementation DefinitionConfigurationTest {
    AssemblyWithDefinitionConfiguration *assembly;
}

- (void)setUp
{
    [super setUp];

    assembly = [[TyphoonBlockComponentFactory factoryWithAssembly:[AssemblyWithDefinitionConfiguration assembly]] asAssembly];
}

- (void)test_macros_defined_definition
{
    XCTAssertEqualObjects([assembly definitionMatchedTrueValue], @"TRUE");
}

- (void)test_runtime_defined_definition
{
    XCTAssertEqualObjects([assembly definitionMatchedRuntimeValue:@YES], @"TRUE");
}

- (void)test_string_defined_definition
{
    XCTAssertEqualObjects([assembly definitionMatchedFalseAsString], @"FALSE");
}

- (void)test_number_defined_definition
{
    XCTAssertEqualObjects([assembly definitionMatchedOneAsNumber], @"TRUE");
}

- (void)test_string_number_defined_definition
{
    XCTAssertEqualObjects([assembly definitionMatchedOneAsString], @"TRUE");
}

- (void)test_definition_defined_by_another_as_option
{
    XCTAssertEqualObjects([assembly definitionMatchedByAnotherDefinitionWithFalse], @"FALSE");
}

- (void)test_definition_matched_by_name
{
    XCTAssertEqualObjects([assembly definitionMatchedDefinitionName:@"trueString"], @"TRUE");
    XCTAssertEqualObjects([assembly definitionMatchedDefinitionName:@"falseString"], @"FALSE");
}

- (void)test_definition_with_custom_matcher
{
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherFromOption:@"positive"], @"TRUE");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherFromOption:@"negative"], @"FALSE");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherFromOption:@"nothing"], @"ZERO");
}

- (void)test_definition_cant_match
{
    XCTAssertThrows([assembly definitionMatchedByCustomMatcherFromOption:@"unknown"]);
    XCTAssertThrows([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"unknown"]);
}

- (void)test_definition_with_custom_matcher_and_name
{
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"positive"], @"TRUE");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"negative"], @"FALSE");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"nothing"], @"ZERO");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"trueString"], @"TRUE");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"falseString"], @"FALSE");
}

- (void)test_definition_cant_match_useDefault
{
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherWithDefaultFromOption:@"unknown"], @"ZERO");
}

@end
