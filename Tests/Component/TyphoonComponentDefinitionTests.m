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
#import "Knight.h"
#import "Typhoon.h"


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
    TyphoonComponentDefinition* definition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];

    assertThat(definition.key, equalTo(@"knight"));
    assertThat(definition.type, equalTo([Knight class]));
}

- (void)test_prevents_initialization_without_supplying_required_parameters
{
    @try
    {
        TyphoonComponentDefinition* definition = [[TyphoonComponentDefinition alloc] init];
        NSLog(@"Def: %@", definition);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property 'clazz' is required."));
    }

    @try
    {
        TyphoonComponentDefinition* definition = [[TyphoonComponentDefinition alloc] initWithClass:nil key:nil];
        NSLog(@"Def: %@", definition);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property 'clazz' is required."));
    }

}

@end

