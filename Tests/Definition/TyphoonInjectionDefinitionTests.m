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
#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "RectModel.h"

@interface TyphoonInjectionDefinitionTests : XCTestCase

@end

@implementation TyphoonInjectionDefinitionTests
{
    MiddleAgesAssembly *_assembly;
}

- (void)setUp {
    _assembly = [[MiddleAgesAssembly assembly] activated];
    [super setUp];
}

- (void)testNull
{
    XCTAssertNil([_assembly nullQuest]);
}

- (void)testNumber
{
    XCTAssertEqualObjects([_assembly simpleNumber], @1);
}

- (void)testBlock
{
    XCTAssertEqualObjects([_assembly blockDefinition](), @"321");
}

- (void)testString
{
    XCTAssertEqualObjects([_assembly simpleString], @"123");
}

- (void)testNullDependency
{
    Knight *knight = [_assembly knightWithNullQuest];

    XCTAssertNotNil(knight);
    XCTAssert([knight isKindOfClass:[Knight class]]);
    XCTAssertNil(knight.quest);
}

- (void)testReferenceDefinition
{
    XCTAssertEqualObjects([_assembly referenceToSimpleString], @"123");
}

- (void)testCollectionOfSimpleStrings
{
    XCTAssertEqualObjects([_assembly simpleArray], (@[@"123", @"123", @"123"]));
}

- (void)testRuntimeArgument
{
    XCTAssertEqualObjects([_assembly simpleRuntimeArgument:@1], @1);
    XCTAssertEqualObjects([_assembly simpleRuntimeArgument:@"123"], @"123");

    NSNumber*(^block)(void) = ^{ return @1; };
    XCTAssertEqualObjects(((id(^)(void))[_assembly simpleRuntimeArgument:block])(), @1);
}

- (void)test_primitive_definition_component
{
    RectModel *rectModel = [_assembly rectModel];
    
    XCTAssertFalse(CGRectEqualToRect(rectModel.rectFrame, CGRectZero));
    
    XCTAssertTrue(rectModel.rectFrame.size.height == 100);
}

- (void)test_double_definition
{
    NSNumber *primitive = [_assembly doublePrimitive];
    
    XCTAssertEqualObjects(primitive, @(123.32));
    
}

@end
