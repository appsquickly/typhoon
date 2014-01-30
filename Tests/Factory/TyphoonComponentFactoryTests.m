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
#import "TyphoonComponentFactoryPostProcessorStubImpl.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "ClassWithConstructor.h"
#import "TyphoonComponentPostProcessorMock.h"


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
        STFail(@"Should have thrown exception");
        knight = nil;
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"More than one component is defined satisfying type: 'Knight'"));
    }

    @try
    {
        Knight* knight = [_componentFactory componentForType:[Champion class]];
        STFail(@"Should have thrown exception");
        knight = nil;
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
        [definition setScope:TyphoonScopeObjectGraph];
        [definition setKey:@"knight"];
    }]];

    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

    Knight* knight = [_componentFactory componentForKey:@"knight"];

    assertThat(knight, notNilValue());
    assertThat(knight, instanceOf([Knight class]));
    assertThat(knight.quest, notNilValue());
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
    assertThat(description, equalTo(@"<TyphoonComponentFactory: _registry=(\n)>"));
}

/* ====================================================================================================================================== */
#pragma mark - Infrastructure components

- (void)test_post_processor_registration
{
    [_componentFactory register:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorStubImpl class]]];
    assertThatUnsignedLong([[_componentFactory registry] count], equalToUnsignedLong(0));
    assertThatUnsignedLong([[_componentFactory factoryPostProcessors] count], equalToUnsignedLong(2)); //Attached + internal processors
}

- (void)test_post_processors_applied
{
    [_componentFactory register:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorStubImpl class]]];
    [_componentFactory register:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorStubImpl class]]];
    [_componentFactory register:[TyphoonDefinition withClass:[Knight class]]];

    [_componentFactory load];

    assertThatUnsignedLong([[_componentFactory factoryPostProcessors] count], equalToUnsignedLong(3)); //Attached + internal processors
    for (TyphoonComponentFactoryPostProcessorStubImpl* stub in _componentFactory.factoryPostProcessors)
    {
        if ([stub isKindOfClass:[TyphoonComponentFactoryPostProcessorStubImpl class]])
        {
            assertThatBool(stub.postProcessingCalled, equalToBool(YES));
        }
    }
}

- (void)test_component_post_processor_registration
{
    [_componentFactory register:[TyphoonDefinition withClass:[TyphoonComponentPostProcessorMock class]]];
    assertThatUnsignedLong([[_componentFactory registry] count], equalToUnsignedLong(0));
    assertThatUnsignedLong([[_componentFactory componentPostProcessors] count], equalToUnsignedLong(1));
}

- (void)test_component_post_processors_applied_in_order
{
    TyphoonComponentPostProcessorMock* processor1 = [[TyphoonComponentPostProcessorMock alloc] initWithOrder:INT_MAX];
    TyphoonComponentPostProcessorMock* processor2 = [[TyphoonComponentPostProcessorMock alloc] initWithOrder:0];
    TyphoonComponentPostProcessorMock* processor3 = [[TyphoonComponentPostProcessorMock alloc] initWithOrder:INT_MIN];
    [_componentFactory addComponentPostProcessor:processor1];
    [_componentFactory addComponentPostProcessor:processor2];
    [_componentFactory addComponentPostProcessor:processor3];
    [_componentFactory register:[TyphoonDefinition withClass:[Knight class]]];

    __block NSMutableArray* orderedApplied = [[NSMutableArray alloc] initWithCapacity:3];
    [processor1 setPostProcessBlock:^id(id o)
    {
        [orderedApplied addObject:@1];
        return o;
    }];
    [processor2 setPostProcessBlock:^id(id o)
    {
        [orderedApplied addObject:@2];
        return o;
    }];
    [processor3 setPostProcessBlock:^id(id o)
    {
        [orderedApplied addObject:@3];
        return o;
    }];

    __unused Knight* knight = [_componentFactory componentForType:[Knight class]];
    assertThat(orderedApplied, equalTo(@[@3, @2, @1]));
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

- (void)test_load_isLoad
{
    [_componentFactory load];
    assertThatBool([_componentFactory isLoaded], is(@YES));
}

- (void)test_unload_isLoad
{
    [_componentFactory load];
    [_componentFactory unload];
    assertThatBool([_componentFactory isLoaded], is(@NO));
}

- (void)test_registery_isLoad
{
    [_componentFactory registry];
    assertThatBool([_componentFactory isLoaded], is(@YES));
}

- (void)test_load_post_processors
{
    id <TyphoonComponentFactoryPostProcessor> postProcessor = mockProtocol(@protocol(TyphoonComponentFactoryPostProcessor));
    [_componentFactory attachPostProcessor:postProcessor];
    [_componentFactory load];
    [_componentFactory load]; // Should do nothing
    [verifyCount(postProcessor, times(1)) postProcessComponentFactory:_componentFactory];
}


- (void)test_load_singleton
{
    [_componentFactory register:[TyphoonDefinition withClass:[CampaignQuest class] properties:^(TyphoonDefinition* definition)
    {
        [definition setScope:TyphoonScopeSingleton];
        [definition setLazy:NO];
    }]];
    [_componentFactory register:[TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition setScope:TyphoonScopeSingleton];
        [definition setLazy:YES];
    }]];
    [_componentFactory register:[TyphoonDefinition withClass:[CavalryMan class] properties:^(TyphoonDefinition* definition)
    {
        [definition setScope:TyphoonScopeObjectGraph];
    }]];
    [_componentFactory load];
    assertThatUnsignedInteger([[_componentFactory singletons] count], is(@1));
}

- (void)test_load_weakSingleton
{
    TyphoonComponentFactory *localFactory = [[TyphoonComponentFactory alloc] init];
    NSString *key = @"WeakSingleton";
    
    [localFactory register:[TyphoonDefinition withClass:[NSMutableString class] properties:^(TyphoonDefinition* definition)
                            {
                                [definition setKey:key];
                                [definition setScope:TyphoonScopeWeakSingleton];
                            }]];
    [localFactory load];
    
    NSMutableString *object1, *object2;
    __weak NSMutableString *weakRef;
    __unsafe_unretained NSMutableString *unsafeRef;
    
    @autoreleasepool {
        object1 = [localFactory componentForKey:key];
        object2 = [localFactory componentForKey:key];
        assertThat(object1, equalTo(object2));
        
        [object1 appendString:@"Hello"];
    }
    
    weakRef = object2;
    unsafeRef = object2;
    
    object1 = nil;
    object2 = nil;
    
    assertThat(weakRef, equalTo(nil));
    
    @autoreleasepool {
        object1 = [localFactory componentForKey:key];
    }
    
    STAssertTrue([object1 rangeOfString:@"Hello"].location == NSNotFound, nil);
}

/* ====================================================================================================================================== */
#pragma mark - Definition Inheritance

//TODO: Move this test to TyphoonDefinitionTests
- (void)test_child_missing_initializer_inherits_parent_initializer_by_definition
{
    TyphoonDefinition* parentDefinition =
            [self registerParentDefinitionWithClass:[ClassWithConstructor class] initializerString:@"parentArgument"];
    TyphoonDefinition
            * childDefinition = [TyphoonDefinition withClass:[ClassWithConstructor class] properties:^(TyphoonDefinition* definition)
    {
        definition.parent = parentDefinition;
    }];
    [_componentFactory register:childDefinition];

    ClassWithConstructor* child = [_componentFactory objectForDefinition:childDefinition];

    assertThat([child string], equalTo(@"parentArgument"));
}

//TODO: Move this test to TyphoonDefinitionTests
- (void)test_child_initializer_overrides_parent_initializer_by_definition
{
    TyphoonDefinition* parentDefinition =
            [self registerParentDefinitionWithClass:[ClassWithConstructor class] initializerString:@"parentArgument"];
    TyphoonDefinition* childDefinition =
            [self registerChildDefinitionWithClass:[ClassWithConstructor class] parentDefinition:parentDefinition initializerString:@"childArgument"];

    ClassWithConstructor* child = [_componentFactory objectForDefinition:childDefinition];

    assertThat([child string], equalTo(@"childArgument"));
}

//TODO: Move this test to TyphoonDefinitionTests
- (void)test_child_initializer_overrides_parent_initializer_by_ref
{
    [self registerParentDefinitionWithClass:[ClassWithConstructor class] key:@"parentRef" initializerString:@"parentArgument"];
    TyphoonDefinition* childDefinition =
            [self registerChildDefinitionWithClass:[ClassWithConstructor class] parentRef:@"parentRef" initializerString:@"childArgument"];

    ClassWithConstructor* child = [_componentFactory objectForDefinition:childDefinition];

    assertThat([child string], equalTo(@"childArgument"));
}


- (void)test_prevents_instantiation_of_abstract_definition
{
    TyphoonDefinition* definition = [TyphoonDefinition withClass:[NSURL class] properties:^(TyphoonDefinition* definition)
    {
        definition.key = @"anAbstractDefinition";
        definition.abstract = YES;
    }];

    [_componentFactory register:definition];

    @try
    {
        __unused NSURL* url = [_componentFactory componentForKey:@"anAbstractDefinition"];
        STFail(@"Should've thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Attempt to instantiate abstract definition: Definition: class='NSURL', key='anAbstractDefinition'"));
    }
}

/* ====================================================================================================================================== */
#pragma mark - Test Utility Methods

- (TyphoonDefinition*)registerParentDefinitionWithClass:(Class)pClass initializerString:(NSString*)string
{
    TyphoonDefinition* parentDefinition = [TyphoonDefinition withClass:pClass key:nil];

    TyphoonInitializer* initializer = [[TyphoonInitializer alloc] init];
    initializer.selector = @selector(initWithString:);
    [initializer injectWithValueAsText:string requiredTypeOrNil:[NSString class]];
    parentDefinition.initializer = initializer;

    [_componentFactory register:parentDefinition];

    return parentDefinition;
}

- (TyphoonDefinition*)registerParentDefinitionWithClass:(Class)pClass key:(NSString*)key initializerString:(NSString*)string
{
    TyphoonDefinition* parentDefinition = [TyphoonDefinition withClass:pClass key:key];

    TyphoonInitializer* initializer = [[TyphoonInitializer alloc] init];
    initializer.selector = @selector(initWithString:);
    [initializer injectWithValueAsText:string requiredTypeOrNil:[NSString class]];
    parentDefinition.initializer = initializer;

    [_componentFactory register:parentDefinition];

    return parentDefinition;
}

- (TyphoonDefinition*)registerChildDefinitionWithClass:(Class)pClass parentDefinition:(TyphoonDefinition*)parentDefinition initializerString:(NSString*)string
{
    return [self registerChildDefinitionWithClass:pClass parentDefinition:parentDefinition parentRef:nil initializerString:string];
}

- (TyphoonDefinition*)registerChildDefinitionWithClass:(Class)pClass parentRef:(NSString*)parentRef initializerString:(NSString*)string
{
    return [self registerChildDefinitionWithClass:pClass parentDefinition:nil parentRef:parentRef initializerString:string];
}

- (TyphoonDefinition*)registerChildDefinitionWithClass:(Class)pClass parentDefinition:(TyphoonDefinition*)parentDefinition parentRef:(NSString*)parentRef initializerString:(NSString*)string
{
    TyphoonDefinition* childDefinition = [TyphoonDefinition withClass:pClass initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithString:);

        [initializer injectWithValueAsText:string requiredTypeOrNil:[NSString class]];
    } properties:^(TyphoonDefinition* definition)
    {
        if (parentDefinition)
        {
            definition.parent = parentDefinition;
        }
        else if (parentRef)
        {
            definition.parent = [TyphoonDefinition withClass:[TyphoonDefinition class] key:parentRef];
        }

    }];
    [_componentFactory register:childDefinition];

    return childDefinition;
}


@end
