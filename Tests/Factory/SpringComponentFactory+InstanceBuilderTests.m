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
#import "Spring.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "SpringComponentInitializer.h"


@interface ComponentDefinition_InstanceBuilderTests : SenTestCase
@end

@implementation ComponentDefinition_InstanceBuilderTests
{
    SpringComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[SpringComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Initializer injection

- (void)test_injects_required_initializer_dependencies
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    SpringComponentInitializer* knightInitializer = [[SpringComponentInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    NSLog(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_injects_required_initializer_dependencies_with_factory_method
{
    SpringComponentDefinition* urlDefinition = [[SpringComponentDefinition alloc] initWithClazz:[NSURL class] key:@"url"];
    SpringComponentInitializer
            * initializer = [[SpringComponentInitializer alloc] initWithSelector:@selector(URLWithString:) isClassMethod:YES];
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
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"quest" withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    NSLog(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_raises_exception_if_property_setter_does_not_exist
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"propertyThatDoesNotExist" withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
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

//- (void)test_injects_property_value_as_long
//{
//    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
//    [knightDefinition injectProperty:@"damselsRescued" withValueAsText:@"12"];
//    [_componentFactory register:knightDefinition];
//
//    Knight* knight = [_componentFactory componentForKey:@"knight"];
//    assertThatLong(knight.damselsRescued, equalToLongLong(12));
//}

- (void)test_injects_initializer_value_as_long
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    SpringComponentInitializer
            * initializer = [[SpringComponentInitializer alloc] initWithSelector:@selector(initWithQuest:damselsRescued:) isClassMethod:NO];
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
        SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@"propertyDoesNotExist" withReference:@"quest"];
        [_componentFactory register:knightDefinition];

        Knight* knight = [_componentFactory componentForKey:@"knight"];
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
        SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@"readOnlyQuest" withReference:@"quest"];
        [_componentFactory register:knightDefinition];

        SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
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
