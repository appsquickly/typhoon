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

#import <SenTestingKit/SenTestingKit.h>
#import <objc/message.h>
#import <Typhoon/OCLogTemplate.h>
#import "Knight.h"
#import "Typhoon.h"
#import "AutoWiringKnight.h"
#import "AutoWiringSubClassedKnight.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonReferenceDefinition.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjections.h"
#import "TyphoonInjectionByCollection.h"
#import "TyphoonMethod+InstanceBuilder.h"

@interface TyphoonDefinitionTests : SenTestCase
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

    assertThat(definition.key, equalTo(@"knight"));
    assertThat(definition.type, equalTo([Knight class]));
}

- (void)test_prevents_initialization_without_supplying_required_parameters
{
    @try {
        TyphoonDefinition *definition = [[TyphoonDefinition alloc] init];
        NSLog(@"Def: %@", definition);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        assertThat([e description], equalTo(@"Property 'clazz' is required."));
    }

    @try {
        TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:nil key:nil];
        NSLog(@"Def: %@", definition);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        assertThat([e description], equalTo(@"Property 'clazz' is required."));
    }
}

/* ====================================================================================================================================== */
#pragma mark - Describing

- (void)test_enumerates_properties_injected_by_value
{
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    //by value
    [definition injectProperty:@selector(foobar) with:@"zzz"];
    [definition injectProperty:@selector(rapunzal) with:@"ttt"];

    //by reference
    [definition injectProperty:@selector(dd) with:TyphoonInjectionWithReference(@"someReference")];

    assertThatUnsignedLongLong([[definition propertiesInjectedByObjectInstance] count], equalToUnsignedLongLong(2));
}

- (void)test_enumerates_properties_injected_by_reference
{
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    //by value
    [definition injectProperty:@selector(foobar) with:@"zzz"];
    [definition injectProperty:@selector(rapunzal) with:@"ttt"];

    //by reference
    [definition injectProperty:@selector(dd) with:TyphoonInjectionWithReference(@"someReference")];

    assertThatUnsignedLongLong([[definition propertiesInjectedByReference] count], equalToUnsignedLongLong(1));
}


/* ====================================================================================================================================== */
#pragma mark - Definition inheritance

- (void)test_inherits_all_parent_properties
{
    TyphoonDefinition *longLostAncestor = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(hasHorseWillTravel) with:@(YES)];
    }];

    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(12)];
        [definition setParent:longLostAncestor];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:@"foobar!"];
        [definition setParent:parent];
    }];

    assertThat([child injectedProperties], hasCountOf(3));
}


- (void)test_child_properties_override_parent_properties
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(12)];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(346)];
        [definition setParent:parent];
    }];

    assertThat([child injectedProperties], hasCountOf(1));

    TyphoonInjectionByObjectInstance *property = [[child injectedProperties] anyObject];
    assertThatInteger([property.objectInstance integerValue], equalToInteger(346));
}

- (void)test_child_inherits_parent_scope_if_not_explicitly_set
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopeSingleton];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(346)];
        [definition setParent:parent];
    }];

    assertThatInt([child scope], equalToInt(TyphoonScopeSingleton));
}

- (void)test_child_overrides_parent_scope_if_explicitly_set
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopeSingleton];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(346)];
        [definition setScope:TyphoonScopePrototype];
        [definition setParent:parent];
    }];

    assertThatInt([child scope], equalToInt(TyphoonScopePrototype));
}


/* ====================================================================================================================================== */
#pragma mark - Auto-wiring

- (void)test_autoWired_properties
{
    NSSet *autoWired = objc_msgSend([AutoWiringKnight class], @selector(typhoonAutoInjectedProperties));
    assertThatUnsignedLongLong([autoWired count], equalToUnsignedLongLong(1));
    assertThat(autoWired, hasItem(@"quest"));

    autoWired = objc_msgSend([AutoWiringSubClassedKnight class], @selector(typhoonAutoInjectedProperties));
    assertThatUnsignedLongLong([autoWired count], equalToUnsignedLongLong(2));
    assertThat(autoWired, hasItem(@"quest"));
    assertThat(autoWired, hasItem(@"foobar"));
}


/* ====================================================================================================================================== */
#pragma mark - Copying

- (void)test_performs_copy
{

    TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {

        [definition injectInitializer:@selector(initWithQuest:damselsRescued:) withParameters:^(TyphoonMethod *initializer) {
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
    assertThat(copy, notNilValue());
    assertThat(copy.type, equalTo([Knight class]));
    assertThat(copy.initializer, notNilValue());
    assertThatBool(copy.initializer.selector == @selector(initWithQuest:damselsRescued:), equalToBool(YES));
    assertThat(copy.initializer.injectedParameters, hasCountOf(2));
    assertThat(copy.injectedProperties, hasCountOf(2));

    TyphoonInjectionByCollection *collection = [[[copy injectedProperties] allObjects] objectAtIndex:0];
    assertThatUnsignedInteger([collection count], equalToUnsignedInteger(2));

}

@end

