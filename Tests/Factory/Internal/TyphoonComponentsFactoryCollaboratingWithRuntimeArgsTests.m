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
#import "TyphoonAssemblyActivator.h"

@interface TyphoonComponentsFactoryCollaboratingWithRuntimeArgsTests : XCTestCase

@end

@implementation TyphoonComponentsFactoryCollaboratingWithRuntimeArgsTests
{
    CollaboratingMiddleAgesAssembly *_assembly;
}

- (void)setUp
{
    [super setUp];

    _assembly = [[CollaboratingMiddleAgesAssembly assembly]
        activateWithCollaboratingAssemblies:@[[MiddleAgesAssembly assembly]]];
}

- (void)test_collaborating_assembly_with_runtime_args
{
    Knight *knight = [_assembly knightWithCollaboratingFoobar:@"Hello"];

    Knight *fried = [knight.friends anyObject];

    XCTAssertTrue([fried.foobar isEqual:@"Hello"]);
}

@end
