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
#import "Spring.h"

#import "Knight.h"
#import "CampaignQuest.h"
#import "CavalryMan.h"
#import "Champion.h"


@interface SpringComponentFactoryTests : SenTestCase
@end

@implementation SpringComponentFactoryTests
{
    SpringComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[SpringComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Dependencies resolved by reference

- (void)test_objectForKey_returns_singleton_with_initializer_dependencies
{

    [_componentFactory register:[SpringComponentDefinition definitionWithClass:[Knight class]
            initializer:^(SpringComponentInitializer* initializer)
            {
                initializer.selector = @selector(initWithQuest:);
                [initializer injectParameterAtIndex:0 withReference:@"quest"];
            }]];

    [_componentFactory register:[SpringComponentDefinition definitionWithClass:[CampaignQuest class] key:@"quest"]];

    Knight* knight = [_componentFactory componentForType:[Knight class]];

    assertThat(knight, notNilValue());
    assertThat(knight, instanceOf([Knight class]));
    assertThat(knight.quest, notNilValue());

    NSLog(@"Here's the knight: %@", knight);
}

- (void)test_objectForKey_raises_exception_if_reference_does_not_exist
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    SpringComponentInitializer* knightInitializer = [[SpringComponentInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    @try
    {
        Knight* knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight);
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"No component matching id 'quest'."));
    }
}

/* ====================================================================================================================================== */
#pragma mark - Dependencies resolved by type

- (void)test_allObjectsForType
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    SpringComponentInitializer* knightInitializer = [[SpringComponentInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition
            * cavalryManDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CavalryMan class] key:@"cavalryMan"];
    [_componentFactory register:cavalryManDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    assertThat([_componentFactory allComponentsForType:[Knight class]], hasCountOf(2));
    assertThat([_componentFactory allComponentsForType:[CampaignQuest class]], hasCountOf(1));
    assertThat([_componentFactory allComponentsForType:@protocol(NSObject)], hasCountOf(3));
}

- (void)test_objectForType
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    SpringComponentInitializer* knightInitializer = [[SpringComponentInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition
            * cavalryManDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CavalryMan class] key:@"cavalryMan"];
    [_componentFactory register:cavalryManDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    assertThat([_componentFactory componentForType:[CavalryMan class]], notNilValue());

    @try
    {
        Knight* knight = [_componentFactory componentForType:[Knight class]];
        NSLog(@"Here's the knight: %@", knight);
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"More than one component is defined satisfying type: 'Knight'"));
    }

    @try
    {
        Knight* knight = [_componentFactory componentForType:[Champion class]];
        NSLog(@"Here's the knight: %@", knight);
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"No components defined which satisify type: 'Champion'"));
    }
}

- (void)test_objectForKey_returns_singleton_with_property_dependencies_resolved_by_type
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"quest"];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory componentForKey:@"knight"];

    assertThat(knight, notNilValue());
    assertThat(knight, instanceOf([Knight class]));
    assertThat(knight.quest, notNilValue());

    NSLog(@"Here's the knight: %@", knight);
}

@end