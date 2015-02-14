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


#import "TyphoonMethod.h"
#import <XCTest/XCTest.h>
#import "MiddleAgesAssembly.h"
#import "Typhoon.h"
#import "Knight.h"

@interface TyphoonInitializerTests : XCTestCase
@end


@implementation TyphoonInitializerTests
{
    TyphoonMethod *_initializer;
    TyphoonComponentFactory *_factory;
}

- (void)setUp
{
    [super setUp];
    _factory = [TyphoonBlockComponentFactory factoryWithAssembly:[MiddleAgesAssembly assembly]];
}


- (void)test_knight_init_by_class_method
{
    Knight *knight = [_factory componentForKey:@"knightClassMethodInit"];
    XCTAssertTrue(knight.damselsRescued == 13, @"");
}

//-------------------------------------------------------------------------------------------
#pragma mark - Utility Methods

- (TyphoonMethod *)newInitializerWithSelector:(SEL)aSelector
{
    TyphoonMethod *anInitializer = [[TyphoonMethod alloc] initWithSelector:aSelector];
    return anInitializer;
}

@end