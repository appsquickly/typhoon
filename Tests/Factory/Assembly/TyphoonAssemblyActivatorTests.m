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
#import "TyphoonAssemblyActivator.h"

@interface TyphoonAssemblyActivatorTests : XCTestCase
@end

@implementation TyphoonAssemblyActivatorTests

- (void)test_activated_assembly_returns_built_instances
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    XCTAssertTrue([[assembly knight] isKindOfClass:[TyphoonDefinition class]]);

    [[TyphoonAssemblyActivator withAssembly:assembly] activate];

    XCTAssertTrue([[assembly knight] isKindOfClass:[Knight class]]);
    NSLog(@"Knight: %@", [assembly knight]);
}

- (void)test_non_activated_assembly_raises_exception_when_invoking_TyphoonComponentFactory_componentForType
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly componentForType:[Knight class]];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"componentForType: requires the assembly to be activated with TyphooonAssemblyActivator",
            [e description]);
    }
}

- (void)test_non_activated_assembly_raises_exception_when_invoking_TyphoonComponentFactory_allComponentsForType
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly allComponentsForType:[Knight class]];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"allComponentsForType: requires the assembly to be activated with TyphooonAssemblyActivator",
            [e description]);
    }
}

- (void)test_non_activated_assembly_raises_exception_when_invoking_TyphoonComponentFactory_componentForKey
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly componentForKey:@"knight"];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"componentForKey: requires the assembly to be activated with TyphooonAssemblyActivator",
            [e description]);
    }
}

- (void)test_non_activated_assembly_raises_exception_when_invoking_TyphoonComponentFactory_inject
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly inject:nil];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"inject: requires the assembly to be activated with TyphooonAssemblyActivator",
            [e description]);
    }
}

- (void)test_non_activated_assembly_raises_exception_when_invoking_TyphoonComponentFactory_inject_withSelector
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly inject:nil withSelector:nil];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"inject:withSelector: requires the assembly to be activated with TyphooonAssemblyActivator",
            [e description]);
    }
}

- (void)test_after_activation_TyphoonComponentFactory_methods_are_available
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    [[TyphoonAssemblyActivator withAssembly:assembly] activate];

    XCTAssertTrue([[assembly componentForKey:@"knight"] isKindOfClass:[Knight class]]);
}


@end