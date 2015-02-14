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
#import "TyphoonBlockComponentFactory.h"
#import "Knight.h"
#import "TyphoonAssemblyActivator.h"

@interface TyphoonAssemblyActivatorTests : XCTestCase
@end

@implementation TyphoonAssemblyActivatorTests

- (void)test_activated_assembly_returns_built_instances
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    XCTAssertTrue([[assembly knight] isKindOfClass:[TyphoonDefinition class]]);

    [[TyphoonAssemblyActivator activatorWithAssemblies:@[assembly]] activate];

    XCTAssertTrue([[assembly knight] isKindOfClass:[Knight class]]);
    NSLog(@"Knight: %@", [assembly knight]);
}

@end