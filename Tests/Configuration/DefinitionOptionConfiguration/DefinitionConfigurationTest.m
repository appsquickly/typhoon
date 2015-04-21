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
#import <XCTest/XCTest.h>
#import "AssemblyWithDefinitionConfiguration.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssemblyActivator.h"

@interface DefinitionConfigurationTest : XCTestCase

@end

@implementation DefinitionConfigurationTest {
    AssemblyWithDefinitionConfiguration *assembly;
}

- (void)setUp
{
    [super setUp];
    assembly = [[AssemblyWithDefinitionConfiguration assembly] activate];
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

- (void)test_definition_with_custom_matcher_and_runtime_args_passing
{
    XCTAssertEqualObjects([assembly definitionMatchedByCustomMatcherFromOption:@"custom" withString:@"123"], @"123");
}

- (void)test_definition_with_custom_injections_on_matcher
{
    XCTAssertEqualObjects([assembly definitionMatchedByCustomInjectionsMatcherFromOption:@"optionItSelf" withString:@"123"],@"optionItSelf");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomInjectionsMatcherFromOption:@"customString" withString:@"123"],@"123");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomInjectionsMatcherFromOption:@"defaultString" withString:nil],@"Typhoon");
    XCTAssertEqualObjects([assembly definitionMatchedByCustomInjectionsMatcherFromOption:(NSString *)[NSNull null] withString:nil],nil);
    XCTAssertEqualObjects([assembly definitionMatchedByCustomInjectionsMatcherFromOption:nil withString:nil],[NSNull null]);
}

- (void)test_definition_with_circular_dependency
{
    NSArray *array = [assembly definitionWithCircularDescription];
    XCTAssertTrue([array count] == 2, @"array must have 2 items, but has: %@",array);
    NSValue *first = array[0];
    NSValue *second = array[1];
    XCTAssertTrue([first pointerValue] == (__bridge void *)array);
    XCTAssertTrue([second pointerValue] == (__bridge void *)array);

}

- (void)test_definition_with_incorrect_circular_dependency
{
    XCTAssertThrows([assembly definitionWithIncorrectCircularDependency]);
}

@end
