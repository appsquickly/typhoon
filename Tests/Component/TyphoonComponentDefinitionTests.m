////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import <objc/message.h>
#import "Knight.h"
#import "Typhoon.h"
#import "AutoWiringKnight.h"
#import "AutoWiringSubClassedKnight.h"


@interface TyphoonComponentDefinitionTests : SenTestCase
@end


@implementation TyphoonComponentDefinitionTests

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
    TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    assertThat(definition.key, equalTo(@"knight"));
    assertThat(definition.type, equalTo([Knight class]));
}

- (void)test_prevents_initialization_without_supplying_required_parameters
{
    @try
    {
        TyphoonDefinition* definition = [[TyphoonDefinition alloc] init];
        NSLog(@"Def: %@", definition);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property 'clazz' is required."));
    }

    @try
    {
        TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:nil key:nil];
        NSLog(@"Def: %@", definition);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property 'clazz' is required."));
    }

}

/* ====================================================================================================================================== */
#pragma mark - Auto-wiring

- (void)test_autoWired_properties
{
    NSSet* autoWired = objc_msgSend([AutoWiringKnight class], @selector(typhoonAutoInjectedProperties));
    assertThatUnsignedLongLong([autoWired count], equalToUnsignedLongLong(1));
    assertThat(autoWired, hasItem(@"quest"));

    autoWired = objc_msgSend([AutoWiringSubClassedKnight class], @selector(typhoonAutoInjectedProperties));
    assertThatUnsignedLongLong([autoWired count], equalToUnsignedLongLong(2));
    assertThat(autoWired, hasItem(@"quest"));
    assertThat(autoWired, hasItem(@"foobar"));
}

@end

