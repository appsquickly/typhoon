////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import <objc/message.h>
#import "OCLogTemplate.h"
#import "Knight.h"
#import "Typhoon.h"
#import "AutoWiringKnight.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonReferenceDefinition.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjections.h"
#import "TyphoonInjectionByCollection.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonDefinition+Tests.h"
#import "ClassForNoSubclass.h"
#import "CampaignQuest.h"

@interface TyphoonDefinitionTests : XCTestCase
@end

@implementation TyphoonDefinitionTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)test_allows_initialization_with_class_and_key_parameters
{
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    XCTAssertEqual(definition.key, @"knight");
    XCTAssertEqual(definition.type, [Knight class]);
}

- (void)test_prevents_initialization_without_supplying_required_parameters
{
    @try {
        TyphoonDefinition *definition = [[TyphoonDefinition alloc] init];
        LogInfo(@"Def: %@", definition);
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Property 'clazz' is required.");
    }

    @try {
        TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:nil key:nil];
        LogInfo(@"Def: %@", definition);
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Property 'clazz' is required.");
    }
    
    @try {
        TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[ClassForNoSubclass class] key:nil];
        LogInfo(@"Def: %@", definition);
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Subclass of NSProxy or NSObject is required.");
    }
    
    @try {
        TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
            [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
                
            }];
        }];
        LogInfo(@"Def: %@", definition);
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Method 'initWithQuest:' has 1 parameters, but 0 was injected. Inject with 'nil' if necessary");
    }
    
    @try {
        TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
            [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
                [initializer injectParameterWith:[NSObject new]];
                [initializer injectParameterWith:[NSObject new]];
            }];
        }];
        LogInfo(@"Def: %@", definition);
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Method 'initWithQuest:' has 1 parameters, but 2 was injected. ");
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Describing

- (void)test_enumerates_properties_injected_by_value
{
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    //by value
    [definition injectProperty:@selector(foobar) with:@"zzz"];
    [definition injectProperty:@selector(rapunzal) with:@"ttt"];

    //by reference
    [definition injectProperty:@selector(dd) with:TyphoonInjectionWithReference(@"someReference")];

    XCTAssertEqual([definition numberOfPropertyInjectionsByObject], 2);
}

- (void)test_enumerates_properties_injected_by_reference
{
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    //by value
    [definition injectProperty:@selector(foobar) with:@"zzz"];
    [definition injectProperty:@selector(rapunzal) with:@"ttt"];

    //by reference
    [definition injectProperty:@selector(dd) with:TyphoonInjectionWithReference(@"someReference")];

    XCTAssertEqual([definition numberOfPropertyInjectionsByReference], (1));
}


//-------------------------------------------------------------------------------------------
#pragma mark - Definition inheritance
//-------------------------------------------------------------------------------------------

- (void)test_inherits_all_parent_properties
{
    TyphoonDefinition *longLostAncestor = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(hasHorseWillTravel) with:@(YES)];
    }];

    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(12)];
        [definition setParent:longLostAncestor];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withParent:parent class:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:@"foobar!"];
    }];

    XCTAssertEqual([[child injectedProperties] count], 3);
}


- (void)test_child_properties_override_parent_properties
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(12)];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withParent:parent class:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(346)];
    }];

    XCTAssertEqual([[child injectedProperties] count], (1));

    TyphoonInjectionByObjectInstance *property = [[child injectedProperties] anyObject];
    XCTAssertEqual([property.objectInstance integerValue], 346);
}

- (void)test_child_inherits_parent_scope_if_not_explicitly_set
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopeSingleton];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withParent:parent class:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(346)];
    }];

    XCTAssertEqual([child scope], (TyphoonScopeSingleton));
}

- (void)test_child_overrides_parent_scope_if_explicitly_set
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopeSingleton];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withParent:parent class:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(346)];
        [definition setScope:TyphoonScopePrototype];
    }];

    XCTAssertEqual([child scope], (TyphoonScopePrototype));
}

- (void)test_throws_exception_if_parent_is_not_definition
{
    id parent = [NSObject new];
    
    TyphoonDefinition *child = [TyphoonDefinition withClass:[Knight class]];
    
    XCTAssertThrows([child setParent:parent]);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Copying
//-------------------------------------------------------------------------------------------


- (void)test_performs_copy
{

    TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {

        [definition useInitializer:@selector(initWithQuest:damselsRescued:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:nil];
            [initializer injectParameterWith:@(12)];
        }];

        [definition injectProperty:@selector(favoriteDamsels) with:@[
            [TyphoonReferenceDefinition definitionReferringToComponent:@"mary"],
            [TyphoonReferenceDefinition definitionReferringToComponent:@"mary"]
        ]];
        [definition injectProperty:@selector(friends) with:[NSSet setWithObject:@"Bob"]];
    }];

    TyphoonDefinition *copy = [definition copy];
    XCTAssertNotNil(copy);
    XCTAssertEqual(copy.type, ([Knight class]));
    XCTAssertNotNil(copy.initializer);
    XCTAssertTrue(copy.initializer.selector == @selector(initWithQuest:damselsRescued:));
    XCTAssertEqual([copy.initializer.injectedParameters count], 2);
    XCTAssertEqual([copy.injectedProperties count], 2);

    [copy enumerateInjectionsOfKind:[TyphoonInjectionByCollection class] options:TyphoonInjectionsEnumerationOptionProperties usingBlock:^(id collection, id *injectionToReplace, BOOL *stop) {
        XCTAssertEqual([collection count], 2);
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Injection Hooks
//-------------------------------------------------------------------------------------------

- (void)test_before_injections
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition performBeforeInjections:@selector(description)];
    }];
    
    XCTAssertEqual(@selector(description), [definition beforeInjections].selector);
}

- (void)test_before_injections_with_parameters_hook
{
    NSUInteger const damselsRescued = 100;
    CampaignQuest *quest = [CampaignQuest new];
    
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition performBeforeInjections:@selector(setQuest:andDamselsRescued:) parameters:^(TyphoonMethod *params) {
            [params injectParameterWith:quest];
            [params injectParameterWith:@(damselsRescued)];
        }];
    }];
    
    XCTAssertEqual(@selector(setQuest:andDamselsRescued:), [definition beforeInjections].selector);
    XCTAssertEqualObjects(quest, [[definition beforeInjections].injectedParameters[0] objectInstance]);
    XCTAssertEqualObjects(@(damselsRescued), [[definition beforeInjections].injectedParameters[1] objectInstance]);
}

- (void)test_after_injections
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition performAfterInjections:@selector(description)];
    }];
    
    XCTAssertEqual(@selector(description), [definition afterInjections].selector);
}

- (void)test_after_injections_with_parameters_hook
{
    NSUInteger const damselsRescued = 100;
    CampaignQuest *quest = [CampaignQuest new];
    
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition performAfterInjections:@selector(setQuest:andDamselsRescued:) parameters:^(TyphoonMethod *params) {
            [params injectParameterWith:quest];
            [params injectParameterWith:@(damselsRescued)];
        }];
    }];
    
    XCTAssertEqual(@selector(setQuest:andDamselsRescued:), [definition afterInjections].selector);
    XCTAssertEqualObjects(quest, [[definition afterInjections].injectedParameters[0] objectInstance]);
    XCTAssertEqualObjects(@(damselsRescued), [[definition afterInjections].injectedParameters[1] objectInstance]);
}

@end

