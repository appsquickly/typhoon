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
#import "MethodInjectinosAssembly.h"
#import "Typhoon.h"
#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "Quest.h"

@interface TyphoonMethodInjectionsTests : XCTestCase

@end

@implementation TyphoonMethodInjectionsTests {
    MethodInjectinosAssembly *factory;
}

- (void)setUp
{
    factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[MiddleAgesAssembly assembly], [MethodInjectinosAssembly assembly]]];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)test_method_injection
{
    Knight *knight = [factory knightInjectedByMethod];
    XCTAssertNotNil(knight.quest);
    XCTAssertEqual((int)knight.damselsRescued, 3);
}

- (void)test_method_circular_injection_with_array
{
    Knight *knight = [factory knightWithCircularDependency];
    
    NSArray *damsels = knight.favoriteDamsels;
    
    Knight *another = damsels[0];
    
    XCTAssertTrue(knight == another.foobar, @"knight=%@, another=%@",knight, another);
    XCTAssertTrue(damsels.count == 2);
}

- (void)test_method_three_argument
{
    Knight *knight = [factory knightWithMethodRuntimeFoo:@"foo"];
    XCTAssertEqualObjects(knight.foobar, @"foo");
}

- (void)test_method_nil_argument
{
    Knight *knight = [factory knightWithMethodFoo:nil];
    
    XCTAssertTrue([knight.friends count] == 2);
    XCTAssertTrue(knight.hasHorseWillTravel);
    XCTAssertTrue(knight.foobar == nil);
}




@end
