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
#import "Typhoon.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonParameterInjectedAsCollection.h"

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
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonInitializer* knightInitializer = [[TyphoonInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    NSLog(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_injects_required_initializer_dependencies_with_factory_method
{
    TyphoonDefinition* urlDefinition = [[TyphoonDefinition alloc] initWithClass:[NSURL class] key:@"url"];
    TyphoonInitializer* initializer = [[TyphoonInitializer alloc] initWithSelector:@selector(URLWithString:) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodYes];
    [initializer injectParameterAtIndex:0 withValueAsText:@"http://www.appsquick.ly" requiredTypeOrNil:[NSString class]];
    [urlDefinition setInitializer:initializer];
    [_componentFactory register:urlDefinition];

    NSURL* url = [_componentFactory buildInstanceWithDefinition:urlDefinition];
    NSLog(@"Here's the bundle: %@", url);
    assertThat(url, notNilValue());
}

- (void)test_injects_initializer_value_as_long
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonInitializer
            * initializer = [[TyphoonInitializer alloc] initWithSelector:@selector(initWithQuest:damselsRescued:) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodNo];
    [initializer injectParameterNamed:@"damselsRescued" withValueAsText:@"12" requiredTypeOrNil:nil];
    [knightDefinition setInitializer:initializer];

    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory componentForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_injects_initializer_value_as_collection
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonInitializer
    * knightInitializer = [[TyphoonInitializer alloc] initWithSelector:@selector(initWithQuest:favoriteDamsels:) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodNo];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightInitializer injectParameterNamed:@"favoriteDamsels" asCollection:^(TyphoonParameterInjectedAsCollection *asCollection) {
        [asCollection addItemWithText:@"damsel1" requiredType:[NSString class]];
        [asCollection addItemWithText:@"damsel2" requiredType:[NSString class]];
    } requiredType:[NSArray class]];
    
    [knightDefinition setInitializer:knightInitializer];
    
    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];
    
    [_componentFactory register:knightDefinition];
    
    Knight* knight = [_componentFactory componentForKey:@"knight"];
    assertThatUnsignedLong([knight.favoriteDamsels count], equalToUnsignedLong(2));
}


/* ====================================================================================================================================== */
#pragma mark - Property injection

- (void)test_injects_required_property_dependencies
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(quest) withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    NSLog(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_raises_exception_if_property_setter_does_not_exist
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(propertyThatDoesNotExist) withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
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
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(damselsRescued) withValueAsText:@"12"];
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
        TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@selector(propertyDoesNotExist) withReference:@"quest"];
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
        TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@selector(readOnlyQuest) withReference:@"quest"];
        [_componentFactory register:knightDefinition];

        TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
        [_componentFactory register:questDefinition];

        Knight* knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight); //suppress unused warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property 'readOnlyQuest' of class 'Knight' is readonly."));
    }
}

@end
