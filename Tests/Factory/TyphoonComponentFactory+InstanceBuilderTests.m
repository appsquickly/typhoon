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
#import <objc/runtime.h>
#import "Typhoon.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "TyphoonComponentInitializer.h"


@interface ComponentDefinition_InstanceBuilderTests : SenTestCase
@end

@implementation ComponentDefinition_InstanceBuilderTests
{
    TyphoonComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[TyphoonComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Initializer injection

- (void)test_injects_required_initializer_dependencies
{
    TyphoonComponentDefinition* knightDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonComponentInitializer* knightInitializer = [[TyphoonComponentInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    TyphoonComponentDefinition* questDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    NSLog(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_injects_required_initializer_dependencies_with_factory_method
{
    TyphoonComponentDefinition* urlDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[NSURL class] key:@"url"];
    TyphoonComponentInitializer
            * initializer = [[TyphoonComponentInitializer alloc] initWithSelector:@selector(URLWithString:) isClassMethod:YES];
    [initializer injectParameterAt:0 withValueAsText:@"http://www.appsquick.ly" requiredTypeOrNil:[NSString class]];
    [urlDefinition setInitializer:initializer];
    [_componentFactory register:urlDefinition];

    NSURL* url = [_componentFactory buildInstanceWithDefinition:urlDefinition];
    NSLog(@"Here's the bundle: %@", url);
    assertThat(url, notNilValue());
}

/* ====================================================================================================================================== */
#pragma mark - Property injection

- (void)test_injects_required_property_dependencies
{
    TyphoonComponentDefinition* knightDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"quest" withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    TyphoonComponentDefinition* questDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    NSLog(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_raises_exception_if_property_setter_does_not_exist
{
    TyphoonComponentDefinition* knightDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"propertyThatDoesNotExist" withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    TyphoonComponentDefinition* questDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    @try
    {
        Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
        NSLog(@"Here's the knight: %@", knight);
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
            @"Tried to inject property 'propertyThatDoesNotExist' on object of type 'Knight', but the instance has no setter for this property."));
    }
}

- (void)test_injects_property_value_as_long
{
    TyphoonComponentDefinition* knightDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"damselsRescued" withValueAsText:@"12"];
    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory componentForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_injects_initializer_value_as_long
{
    TyphoonComponentDefinition* knightDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonComponentInitializer
            * initializer = [[TyphoonComponentInitializer alloc] initWithSelector:@selector(initWithQuest:damselsRescued:) isClassMethod:NO];
    [initializer injectParameterNamed:@"damselsRescued" withValueAsText:@"12" requiredTypeOrNil:nil];
    [knightDefinition setInitializer:initializer];

    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory componentForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

/* ====================================================================================================================================== */
#pragma mark - Property injection error handling

- (void)test_raises_exception_if_property_has_no_setter
{
    @try
    {
        TyphoonComponentDefinition* knightDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@"propertyDoesNotExist" withReference:@"quest"];
        [_componentFactory register:knightDefinition];

        Knight* knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight); //Suppress unused warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
            @"Tried to inject property 'propertyDoesNotExist' on object of type 'Knight', but the instance has no setter for this property."));
    }

}

- (void)test_raises_exception_if_property_is_readonly
{
    @try
    {
        TyphoonComponentDefinition* knightDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@"readOnlyQuest" withReference:@"quest"];
        [_componentFactory register:knightDefinition];

        TyphoonComponentDefinition* questDefinition = [[TyphoonComponentDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
        [_componentFactory register:questDefinition];

        Knight* knight = [_componentFactory componentForKey:@"knight"];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property 'readOnlyQuest' of class 'Knight' is readonly."));
    }
}

@end
