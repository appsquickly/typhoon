//
//  DefinitionConfigurationTest.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 22.05.14.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "AssemblyWithDefinitionConfiguration.h"
#import "TyphoonBlockComponentFactory.h"

@interface DefinitionConfigurationTest : SenTestCase

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
    STAssertEqualObjects([assembly definitionMatchedTrueValue], @"TRUE", nil);
}

- (void)test_runtime_defined_definition
{
    STAssertEqualObjects([assembly definitionMatchedRuntimeValue:@YES], @"TRUE", nil);
}

- (void)test_string_defined_definition
{
    STAssertEqualObjects([assembly definitionMatchedFalseAsString], @"FALSE", nil);
}

- (void)test_number_defined_definition
{
    STAssertEqualObjects([assembly definitionMatchedOneAsNumber], @"TRUE", nil);
}

- (void)test_string_number_defined_definition
{
    STAssertEqualObjects([assembly definitionMatchedOneAsString], @"TRUE", nil);
}

- (void)test_definition_defined_by_another_as_option
{
    STAssertEqualObjects([assembly definitionMatchedByAnotherDefinitionWithFalse], @"FALSE", nil);
}

- (void)test_definition_matched_by_name
{
    STAssertEqualObjects([assembly definitionMatchedDefinitionName:@"trueString"], @"TRUE", nil);
    STAssertEqualObjects([assembly definitionMatchedDefinitionName:@"falseString"], @"FALSE", nil);
}

- (void)test_definition_with_custom_matcher
{
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherFromOption:@"positive"], @"TRUE", nil);
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherFromOption:@"negative"], @"FALSE", nil);
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherFromOption:@"nothing"], @"ZERO", nil);
}

- (void)test_definition_cant_match
{
    STAssertThrows([assembly definitionMatchedByCustomMatcherFromOption:@"unknown"], nil);
    STAssertThrows([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"unknown"], nil);
}

- (void)test_definition_with_custom_matcher_and_name
{
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"positive"], @"TRUE", nil);
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"negative"], @"FALSE", nil);
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"nothing"], @"ZERO", nil);
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"trueString"], @"TRUE", nil);
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherOrNameFromOption:@"falseString"], @"FALSE", nil);
}

- (void)test_definition_cant_match_useDefault
{
    STAssertEqualObjects([assembly definitionMatchedByCustomMatcherWithDefaultFromOption:@"unknown"], @"ZERO", nil);
}

@end
