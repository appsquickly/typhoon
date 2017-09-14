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
#import "NSArray+TyphoonManualEnumeration.h"

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

- (NSArray *)dummyArray
{
    return [@[@1, @2, @3, @4, @5, @6, @7] copy];
}

- (void)test_array_enumerator
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for manual iteration"];
    
    [[self dummyArray] typhoon_enumerateObjectsWithManualIteration:^(id object, id<TyphoonIterator> iterator) {
        NSLog(@"object: %@", object);
        [(NSObject *)iterator performSelector:@selector(next) withObject:nil afterDelay:0.1];
    } completion:^{
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        
    }];
}



@end
