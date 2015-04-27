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
        NSLog(@"Def: %@", definition);
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Property 'clazz' is required.");
    }

    @try {
        TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:nil key:nil];
        NSLog(@"Def: %@", definition);
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Property 'clazz' is required.");
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

@end

