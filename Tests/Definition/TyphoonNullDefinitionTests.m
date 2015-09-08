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

@interface TyphoonNullDefinitionTests : XCTestCase

@end

@implementation TyphoonNullDefinitionTests
{
    MiddleAgesAssembly *_assembly;
}

- (void)setUp {
    _assembly = [[MiddleAgesAssembly assembly] activate];
    [super setUp];
}

- (void)testNull
{
    XCTAssertNil([_assembly nullQuest]);
}

- (void)testNullDependency
{
    Knight *knight = [_assembly knightWithNullQuest];

    XCTAssertNotNil(knight);
    XCTAssert([knight isKindOfClass:[Knight class]]);
    XCTAssertNil(knight.quest);
}

@end
