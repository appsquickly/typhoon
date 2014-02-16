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
#import "TyphoonPropertyInjectedAsObjectInstance.h"
#import "CampaignQuest.h"
#import "TyphoonReferenceDefinition.h"

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
    [definition injectProperty:@selector(foobar) withValueAsText:@"zzz"];
    [definition injectProperty:@selector(rapunzal) withValueAsText:@"ttt"];

    //by reference
    [definition injectProperty:@selector(dd) withReference:@"someReference"];

    assertThatUnsignedLongLong([[definition propertiesInjectedByValue] count], equalToUnsignedLongLong(2));
}

- (void)test_enumerates_properties_injected_by_reference
{
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    //by value
    [definition injectProperty:@selector(foobar) withValueAsText:@"zzz"];
    [definition injectProperty:@selector(rapunzal) withValueAsText:@"ttt"];

    //by reference
    [definition injectProperty:@selector(dd) withReference:@"someReference"];

    assertThatUnsignedLongLong([[definition propertiesInjectedByReference] count], equalToUnsignedLongLong(1));
}


/* ====================================================================================================================================== */
#pragma mark - Definition inheritance

- (void)test_inherits_all_parent_properties
{
    TyphoonDefinition *longLostAncestor = [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(hasHorseWillTravel) withObjectInstance:@(YES)];
    }];

    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) withObjectInstance:@(12)];
        [definition setParent:longLostAncestor];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) withValueAsText:@"foobar!"];
        [definition setParent:parent];
    }];

    assertThat([child injectedProperties], hasCountOf(3));
}


- (void)test_child_properties_override_parent_properties
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) withObjectInstance:@(12)];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) withObjectInstance:@(346)];
        [definition setParent:parent];
    }];

    assertThat([child injectedProperties], hasCountOf(1));

    TyphoonPropertyInjectedAsObjectInstance *property = [[child injectedProperties] anyObject];
    assertThatInteger([property.objectInstance integerValue], equalToInteger(346));
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

    TyphoonDefinition *definition = [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithQuest:damselsRescued:);
        [initializer injectWithDefinition:nil];
        [initializer injectWithObjectInstance:@(12)];
    } properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(favoriteDamsels) asCollection:^(TyphoonPropertyInjectedAsCollection *collection) {
            [collection addItemWithDefinition:[TyphoonReferenceDefinition definitionReferringToComponent:@"mary"]];
            [collection addItemWithDefinition:[TyphoonReferenceDefinition definitionReferringToComponent:@"mary"]];
        }];
        [definition injectProperty:@selector(friends) asCollection:^(TyphoonPropertyInjectedAsCollection *collection) {
            [collection addItemWithText:@"Bob" requiredType:[NSString class]];
        }];
    }];

    TyphoonDefinition *copy = [definition copy];
    assertThat(copy, notNilValue());
    assertThat(copy.type, equalTo([Knight class]));
    assertThat(copy.initializer, notNilValue());
    assertThatBool(copy.initializer.selector == @selector(initWithQuest:damselsRescued:), equalToBool(YES));
    assertThat(copy.initializer.injectedParameters, hasCountOf(2));
    assertThat(copy.injectedProperties, hasCountOf(2));

    TyphoonPropertyInjectedAsCollection *collection = [[[copy injectedProperties] allObjects] objectAtIndex:0];
    assertThat([collection values], hasCountOf(2));

    LogDebug(@"Values: %@", [collection values]);

}

@end

