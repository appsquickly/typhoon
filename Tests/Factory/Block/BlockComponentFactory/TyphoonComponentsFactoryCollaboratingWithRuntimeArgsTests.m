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


#import "TyphoonBlockComponentFactory.h"
#import <XCTest/XCTest.h>
#import "CollaboratingMiddleAgesAssembly.h"
#import "MiddleAgesAssembly.h"
#import "Knight.h"

@interface TyphoonComponentsFactoryCollaboratingWithRuntimeArgsTests : XCTestCase

@end

@implementation TyphoonComponentsFactoryCollaboratingWithRuntimeArgsTests {
    CollaboratingMiddleAgesAssembly *assembly;
}

- (void)setUp
{
    [super setUp];

    assembly = [[[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
        [CollaboratingMiddleAgesAssembly assembly],
        [MiddleAgesAssembly assembly]
    ]] asAssembly];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)test_collaborating_assembly_with_runtime_args
{
    Knight *knight = [assembly knightWithCollaboratingFoobar:@"Hello"];

    Knight *fried = [knight.friends anyObject];

    XCTAssertTrue([fried.foobar isEqual:@"Hello"]);
}

@end
