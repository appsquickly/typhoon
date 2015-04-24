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
#import "CollaboratingMiddleAgesAssembly.h"
#import "Quest.h"

@interface TyphoonAssemblyTests : XCTestCase
@end

@implementation TyphoonAssemblyTests

- (void)test_activated_assembly_returns_built_instances
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    XCTAssertTrue([[assembly knight] isKindOfClass:[TyphoonDefinition class]]);

    [assembly activate];

    XCTAssertTrue([[assembly knight] isKindOfClass:[Knight class]]);
    NSLog(@"Knight: %@", [assembly knight]);
}

- (void)test_activated_assembly_returns_activated_collaborators
{
    MiddleAgesAssembly *assembly = [[MiddleAgesAssembly assembly] activateWithCollaboratingAssemblies:@[
        [CollaboratingMiddleAgesAssembly assembly]
    ]];

    id<Quest> quest = assembly.collaboratingAssembly.quests.environmentDependentQuest;
    NSLog(@"Got quest: %@", quest);
    XCTAssertTrue([quest conformsToProtocol:@protocol(Quest)]);
}

- (void)test_before_activation_raises_exception_when_invoking_TyphoonComponentFactory_componentForType
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly componentForType:[Knight class]];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"componentForType: requires the assembly to be activated.", [e description]);
    }
}

- (void)test_before_activation_raises_exception_when_invoking_TyphoonComponentFactory_allComponentsForType
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly allComponentsForType:[Knight class]];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"allComponentsForType: requires the assembly to be activated.", [e description]);
    }
}

- (void)test_before_activation_raises_exception_when_invoking_TyphoonComponentFactory_componentForKey
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly componentForKey:@"knight"];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"componentForKey: requires the assembly to be activated.", [e description]);
    }
}

- (void)test_before_activation_raises_exception_when_invoking_TyphoonComponentFactory_inject
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly inject:nil];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"inject: requires the assembly to be activated.", [e description]);
    }
}

- (void)test_before_activation_raises_exception_when_invoking_TyphoonComponentFactory_inject_withSelector
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly inject:nil withSelector:nil];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"inject:withSelector: requires the assembly to be activated.", [e description]);
    }
}

- (void)test_before_activation_raises_exception_when_invoking_TyphoonComponentFactory_makeDefault
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly makeDefault];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"makeDefault requires the assembly to be activated.", [e description]);
    }
}

- (void)test_before_activation_raises_exception_when_invoking_attachPostProcessor
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        [assembly attachPostProcessor:nil];
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"attachPostProcessor: requires the assembly to be activated.", [e description]);
    }
}

- (void)test_after_activation_TyphoonComponentFactory_methods_are_available
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    [assembly activate];

    XCTAssertTrue([[assembly componentForKey:@"knight"] isKindOfClass:[Knight class]]);
}

- (void)test_after_activation_can_inject_pre_obtained_instance
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    [assembly activate];

    Knight *knight = [[Knight alloc] init];
    [assembly inject:knight withSelector:@selector(knight)];
    XCTAssertNotNil(knight.quest);
}

- (void)test_after_activation_assembly_can_be_made_default
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    [assembly activate];
    [assembly makeDefault];
}


@end