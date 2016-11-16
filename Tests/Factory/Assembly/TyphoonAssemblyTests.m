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
#import "TyphoonLoopedCollaboratingAssemblies.h"
#import "MediocreQuest.h"
#import "OCLogTemplate.h"
#import "TyphoonPatcher.h"
#import "TyphoonInstancePostProcessorMock.h"
#import "NSNullTypeConverter.h"

@interface TyphoonAssemblyTests : XCTestCase
@end

@implementation TyphoonAssemblyTests

- (void)test_activated_assembly_returns_built_instances
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    XCTAssertTrue([[assembly knight] isKindOfClass:[TyphoonDefinition class]]);

    assembly = [assembly activate];

    XCTAssertTrue([[assembly knight] isKindOfClass:[Knight class]]);
    LogInfo(@"Knight: %@", [assembly knight]);
}

- (void)test_activated_assembly_returns_activated_collaborators
{
    MiddleAgesAssembly *assembly = [[MiddleAgesAssembly assembly] activateWithCollaboratingAssemblies:@[
        [CollaboratingMiddleAgesAssembly assembly]
    ]];

    id<Quest> quest = assembly.collaboratingAssembly.quests.environmentDependentQuest;
    LogInfo(@"Got quest: %@", quest);
    XCTAssertTrue([quest conformsToProtocol:@protocol(Quest)]);
}

- (void)test_activation_with_looped_collaborators_1_2_3_2
{
    /**
     *  The name of this test contains the collaborators tree structure: 1 -> 2 -> 3 -> 2
     *  We need a couple of similar tests to be sure in the absence of edge cases.
     */
    TyphoonFirstLoopAssembly *firstAssembly = [TyphoonFirstLoopAssembly assembly];
    firstAssembly = [firstAssembly activateWithCollaboratingAssemblies:@[
                                                        [TyphoonSecondLoopAssembly new],
                                                        [TyphoonThirdLoopAssembly new]
                                                        ]];
    id<Quest> quest = [firstAssembly testQuest];
    
    XCTAssertNotNil(quest);
    XCTAssertTrue([quest isKindOfClass:[MediocreQuest class]]);
}

- (void)test_activation_with_looped_collaborators_1_2_1
{
    TyphoonFourthLoopAssembly *fourthAssembly = [TyphoonFourthLoopAssembly assembly];
    fourthAssembly = [fourthAssembly activateWithCollaboratingAssemblies:@[
                                                         [TyphoonFifthLoopAssembly new]
                                                         ]];
    id<Quest> quest = [fourthAssembly testQuest];
    
    XCTAssertNotNil(quest);
    XCTAssertTrue([quest isKindOfClass:[MediocreQuest class]]);
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

- (void)test_before_activation_raises_exception_when_invoking_subscription
{
    @try {
        MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
        id result = assembly[@"test"];
        LogInfo(@"%@", result);
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"objectForKeyedSubscript: requires the assembly to be activated.", [e description]);
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

- (void)test_nil_definition_with_injection_hooks
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    [assembly activate];

    @try {
        Knight *knight = [assembly occasionallyNilKnightWithBeforeInjections];
        [knight description];
    }
    @catch (NSException *e) {
        XCTAssertNil(e);
    }
    
    @try {
        Knight *knight = [assembly occasionallyNilKnightWithAfterInjections];
        [knight description];
    }
    @catch (NSException *e) {
        XCTAssertNil(e);
    }
    
    @try {
        Knight *knight = [assembly occasionallyNilKnightWithMethodInjections];
        [knight description];
    }
    @catch (NSException *e) {
        XCTAssertNil(e);
    }
}

- (void)test_before_activation_preattaches_infrastructure_components
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    
    TyphoonPatcher *patcher = [TyphoonPatcher new];
    [assembly attachDefinitionPostProcessor:patcher];
    
    TyphoonInstancePostProcessorMock *instancePostProcessor = [TyphoonInstancePostProcessorMock new];
    [assembly attachInstancePostProcessor:instancePostProcessor];
    
    NSNullTypeConverter *typeConverter = [NSNullTypeConverter new];
    [assembly attachTypeConverter:typeConverter];
    
    TyphoonBlockComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:assembly];
    
    NSArray *attachedDefinitionPostProcessors = factory.definitionPostProcessors;
    BOOL isPatcherAttached = [attachedDefinitionPostProcessors containsObject:patcher];
    
    NSArray *attachedInstancePostProcessors = factory.instancePostProcessors;
    BOOL isInstancePostProcessorAttached = [attachedInstancePostProcessors containsObject:instancePostProcessor];
    
    BOOL isTypeConverterAttached = [factory.typeConverterRegistry converterForType:[typeConverter supportedType]] != nil;
    
    XCTAssertTrue(isPatcherAttached);
    XCTAssertTrue(isInstancePostProcessorAttached);
    XCTAssertTrue(isTypeConverterAttached);
}

@end
