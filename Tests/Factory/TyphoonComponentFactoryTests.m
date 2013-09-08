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
#import "CavalryMan.h"
#import "Champion.h"
#import "AutoWiringKnight.h"
#import "Harlot.h"
#import "TyphoonComponentFactoryPostProcessorMock.h"
#import "TyphoonPatcher.h"

static NSString* const DEFAULT_QUEST = @"quest";

@interface TyphoonComponentFactoryTests : SenTestCase
@end

@implementation TyphoonComponentFactoryTests
{
    TyphoonComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[TyphoonComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Dependencies resolved by reference

- (void)test_componentForKey_returns_with_initializer_dependencies_injected
{

    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectParameterAtIndex:0 withReference:DEFAULT_QUEST];
    }]];

    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] key:DEFAULT_QUEST]];

    Knight* knight = [_componentFactory componentForType:[Knight class]];

    assertThat(knight, notNilValue());
    assertThat(knight, instanceOf([Knight class]));
    assertThat(knight.quest, notNilValue());

    NSLog(@"Here's the knight: %@", knight);
}

- (void)test_componentForKey_raises_exception_if_reference_does_not_exist
{
    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectParameterAtIndex:0 withReference:DEFAULT_QUEST];
    } properties:^(TyphoonDefinition* definition)
    {
        definition.key = @"knight";
    }]];

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

- (void)test_componentForKey_returns_nil_for_nil_argument
{
    id value = [_componentFactory componentForKey:nil];
    assertThat(value, nilValue());
}

/* ====================================================================================================================================== */
#pragma mark - Dependencies resolved by type

- (void)test_allComponentsForType
{

    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        [initializer setSelector:@selector(initWithQuest:)];
        [initializer injectParameterNamed:@"quest" withReference:@"quest"];
    } properties:^(TyphoonDefinition* definition)
    {
        definition.key = @"knight";
    }]];

    [_componentFactory register:[TyphoonDefinition withClass:[CavalryMan class] key:@"cavalryMan"]];
    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

    assertThat([_componentFactory allComponentsForType:[Knight class]], hasCountOf(2));
    assertThat([_componentFactory allComponentsForType:[CampaignQuest class]], hasCountOf(1));
    assertThat([_componentFactory allComponentsForType:@protocol(NSObject)], hasCountOf(3));
}

- (void)test_componentForType
{

    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        [initializer setSelector:@selector(initWithQuest:)];
        [initializer injectParameterNamed:@"quest" withReference:@"quest"];
    } properties:^(TyphoonDefinition* definition)
    {
        definition.key = @"knight";
    }]];

    [_componentFactory register:[TyphoonDefinition withClass:[CavalryMan class] key:@"cavalryMan"]];
    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

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

    @try
    {
        id <Harlot> harlot = [_componentFactory componentForType:@protocol(Harlot)];
        NSLog(@"Harlot: %@", harlot); //suppress unused variable warning
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"No components defined which satisify type: 'id<Harlot>'"));
    }
}

- (void)test_componentForKey_returns_with_property_dependencies_resolved_by_type
{

    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(quest)];
        [definition setScope:TyphoonScopeDefault];
        [definition setKey:@"knight"];
    }]];

    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

    Knight* knight = [_componentFactory componentForKey:@"knight"];

    assertThat(knight, notNilValue());
    assertThat(knight, instanceOf([Knight class]));
    assertThat(knight.quest, notNilValue());

    NSLog(@"Here's the knight: %@", knight);
}

/* ====================================================================================================================================== */
#pragma mark - Auto-wiring

- (void)test_autoWires
{
    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class]]];

    Knight* knight = [_componentFactory componentForType:[AutoWiringKnight class]];
    assertThat(knight.quest, notNilValue());
}

/* ====================================================================================================================================== */
#pragma mark - Description

- (void)test_able_to_describe_itself
{
    NSString* description = [_componentFactory description];
    NSLog(@"Description: %@", description);
    assertThat(description, equalTo(@"<TyphoonComponentFactory: _registry=(\n)>"));
}

/* ====================================================================================================================================== */
#pragma mark - Infrastructure components

- (void)test_mutator_to_post_processor_migration
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  [_componentFactory attachMutator:[[TyphoonPropertyPlaceholderConfigurer alloc] init]];
  [_componentFactory attachMutator:[[TyphoonPatcher alloc] init]];
#pragma clang diagnostic pop
  
  assertThatInt([[_componentFactory postProcessors] count], equalToInt(2));
}

- (void)test_post_processor_registration
{
  [_componentFactory register:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorMock class]]];
   assertThatInt([[_componentFactory registry] count], equalToInt(0));
   assertThatInt([[_componentFactory postProcessors] count], equalToInt(1));
}

- (void)test_post_processors_applied
{
  [_componentFactory register:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorMock class]]];
  [_componentFactory register:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorMock class]]];
  [_componentFactory register:[TyphoonDefinition withClass:[Knight class]]];
  
  [_componentFactory load];

  assertThatInt([[_componentFactory postProcessors] count], equalToInt(2));
  for (TyphoonComponentFactoryPostProcessorMock *mock in _componentFactory.postProcessors) {
    assertThatBool(mock.postProcessingCalled, equalToBool(YES));
  }
  
}


/* ====================================================================================================================================== */
#pragma mark - Inject properties

- (void)test_injectProperties
{
    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(quest)];
    }]];
    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];
    
    Knight* knight = [[Knight alloc] init];
    [_componentFactory injectProperties:knight];
    
    assertThat(knight.quest, notNilValue());

}

- (void)test_injectProperties_subclassing
{
    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
                                 {
                                     [definition injectProperty:@selector(quest)];
                                 }]];
    [_componentFactory register:[TyphoonDefinition withClass:[CavalryMan class] properties:^(TyphoonDefinition* definition)
                                 {
                                     [definition injectProperty:@selector(hitRatio) withValueAsText:@"3.0"];
                                 }]];
    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];
    
    CavalryMan* cavalryMan = [[CavalryMan alloc] init];
    [_componentFactory injectProperties:cavalryMan];
    
    assertThat(cavalryMan.quest, nilValue());
    assertThatFloat(cavalryMan.hitRatio, equalToFloat(3.0f));
    
    Knight* knight = [[Knight alloc] init];
    [_componentFactory injectProperties:knight];
    
    assertThat(knight.quest, notNilValue());
}

- (void)test_load_isLoad {
	[_componentFactory load];
	assertThatBool([_componentFactory isLoaded], is(@YES));
}

- (void)test_unload_isLoad {
	[_componentFactory load];
	[_componentFactory unload];
	assertThatBool([_componentFactory isLoaded], is(@NO));
}

- (void)test_registery_isLoad {
	[_componentFactory registry];
	assertThatBool([_componentFactory isLoaded], is(@YES));
}

- (void)test_load_mutators {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  id<TyphoonComponentFactoryMutator> mutator = mockProtocol(@protocol(TyphoonComponentFactoryMutator));
	[_componentFactory attachMutator:mutator];
#pragma clang diagnostic pop

	[_componentFactory load];
	[_componentFactory load]; // Should do nothing
	[verifyCount(mutator, times(1)) mutateComponentDefinitionsIfRequired:[_componentFactory registry]];
  [verifyCount(mutator, times(1)) newDefinitionsToRegister];  
}

- (void)test_load_post_processors {
	id<TyphoonComponentFactoryPostProcessor> postProcessor = mockProtocol(@protocol(TyphoonComponentFactoryPostProcessor));
	[_componentFactory attachPostProcessor:postProcessor];
	[_componentFactory load];
	[_componentFactory load]; // Should do nothing
	[verifyCount(postProcessor, times(1)) postProcessComponentFactory:_componentFactory];
}


- (void)test_load_singleton {
	[_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] properties:^(TyphoonDefinition *definition) {
		[definition setScope:TyphoonScopeSingleton];
		[definition setLazy:NO];
	}]];
	[_componentFactory register:[TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
		[definition setScope:TyphoonScopeSingleton];
		[definition setLazy:YES];
    }]];
	[_componentFactory register:[TyphoonDefinition withClass:[CavalryMan class] properties:^(TyphoonDefinition *definition) {
		[definition setScope:TyphoonScopeDefault];
		[definition setLazy:YES];
    }]];
	[_componentFactory load];
	assertThatUnsignedInteger([[_componentFactory singletons] count], is(@1));
}


@end