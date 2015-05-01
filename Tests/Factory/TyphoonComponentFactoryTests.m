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

#import <XCTest/XCTest.h>
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
#import "TyphoonInstancePostProcessorMock.h"
#import "TyphoonInjections.h"
#import "MediocreQuest.h"

static NSString *const DEFAULT_QUEST = @"quest";

@interface TyphoonComponentFactoryTests : XCTestCase
@end

@implementation TyphoonComponentFactoryTests
{
    TyphoonComponentFactory *_componentFactory;
    NSUInteger internalPostProcessorsCount;
}

- (void)setUp
{
    _componentFactory = [[TyphoonComponentFactory alloc] init];
    internalPostProcessorsCount = [[_componentFactory definitionPostProcessors] count];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Dependencies resolved by reference

- (void)test_componentForKey_returns_with_initializer_dependencies_injected
{

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonInjectionWithReference(DEFAULT_QUEST)];
        }];
    }]];

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class] key:DEFAULT_QUEST]];

    Knight *knight = [_componentFactory componentForType:[Knight class]];

    XCTAssertNotNil(knight);
    XCTAssertTrue([knight isKindOfClass:[Knight class]]);
    XCTAssertNotNil(knight.quest);
}

- (void)test_componentForKey_raises_exception_if_reference_does_not_exist
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonInjectionWithReference(DEFAULT_QUEST)];
        }];
        definition.key = @"knight";
    }]];

    @try {
        Knight *knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight);
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"No component matching id 'quest'.");
    }
}

- (void)test_componentForKey_returns_nil_for_nil_argument
{
    id value = [_componentFactory componentForKey:nil];
    XCTAssertNil(value);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Dependencies resolved by type

- (void)test_allComponentsForType
{

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonInjectionWithReference(@"quest")];
        }];
        definition.key = @"knight";
    }]];

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CavalryMan class] key:@"cavalryMan"]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

    XCTAssertTrue([[_componentFactory allComponentsForType:[Knight class]] count] == 2);
    XCTAssertTrue([[_componentFactory allComponentsForType:[CampaignQuest class]] count] == 1);
    XCTAssertTrue([[_componentFactory allComponentsForType:@ protocol(NSObject)] count] == 3);
}

- (void)test_componentForType
{

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonInjectionWithReference(@"quest")];
        }];
        definition.key = @"knight";
    }]];

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CavalryMan class] key:@"cavalryMan"]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[MediocreQuest class] key:@"unimpressiveQuest"]];

    XCTAssertNotNil([_componentFactory componentForType:[CavalryMan class]]);

    XCTAssertThrows([_componentFactory componentForType:[Knight class]], @"More than one component is defined satisfying type: 'Knight'");

    XCTAssertThrows([_componentFactory componentForType:@protocol(Quest)], @"More than one component is defined satisfying type: 'id<Quest>'");

    XCTAssertThrows([_componentFactory componentForType:[Champion class]], @"No components defined which satisify type: 'Champion'");

    XCTAssertThrows([_componentFactory componentForType:@protocol(Harlot)], @"No components defined which satisify type: 'id<Harlot>'");
}

- (void)test_componentForKey_returns_with_property_dependencies_resolved_by_type
{

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest)];
        [definition setScope:TyphoonScopeObjectGraph];
        [definition setKey:@"knight"];
    }]];

    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

    Knight *knight = [_componentFactory componentForKey:@"knight"];

    XCTAssertNotNil(knight);
    XCTAssertTrue([knight isKindOfClass:[Knight class]]);
    XCTAssertNotNil(knight.quest);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Auto-wiring

- (void)test_autoWires
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class]]];

    Knight *knight = [_componentFactory componentForType:[AutoWiringKnight class]];
    XCTAssertNotNil(knight.quest);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Description

- (void)test_able_to_describe_itself
{
    NSString *description = [_componentFactory description];
    XCTAssertEqualObjects(description, @"<TyphoonComponentFactory: _registry=(\n)>");
}

//-------------------------------------------------------------------------------------------
#pragma  mark - Infrastructure components

- (void)test_post_processor_registration
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorStubImpl class]]];
    XCTAssertEqual([[_componentFactory registry] count], 0);
    XCTAssertEqual([[_componentFactory definitionPostProcessors] count], internalPostProcessorsCount + 1); //Attached + internal processors
}

- (void)test_post_processors_applied
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorStubImpl class]]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[TyphoonComponentFactoryPostProcessorStubImpl class]]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class]]];

    [_componentFactory load];

    XCTAssertEqual([[_componentFactory definitionPostProcessors] count], internalPostProcessorsCount + 2); //Attached + internal processors
    for (TyphoonComponentFactoryPostProcessorStubImpl *stub in _componentFactory.definitionPostProcessors) {
        if ([stub isKindOfClass:[TyphoonComponentFactoryPostProcessorStubImpl class]]) {
            XCTAssertTrue(stub.postProcessingCalled);
        }
    }
}

- (void)test_component_post_processor_registration
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[TyphoonInstancePostProcessorMock class]]];
    XCTAssertEqual([[_componentFactory registry] count], 0);
    XCTAssertEqual([[_componentFactory instancePostProcessors] count], 1);
}

- (void)test_component_post_processors_applied_in_order
{
    TyphoonInstancePostProcessorMock*processor1 = [[TyphoonInstancePostProcessorMock alloc] initWithOrder:INT_MAX];
    TyphoonInstancePostProcessorMock*processor2 = [[TyphoonInstancePostProcessorMock alloc] initWithOrder:0];
    TyphoonInstancePostProcessorMock*processor3 = [[TyphoonInstancePostProcessorMock alloc] initWithOrder:INT_MIN];
    [_componentFactory addInstancePostProcessor:processor1];
    [_componentFactory addInstancePostProcessor:processor2];
    [_componentFactory addInstancePostProcessor:processor3];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class]]];

    __block NSMutableArray *orderedApplied = [[NSMutableArray alloc] initWithCapacity:3];
    [processor1 setPostProcessBlock:^id(id o) {
        [orderedApplied addObject:@1];
        return o;
    }];
    [processor2 setPostProcessBlock:^id(id o) {
        [orderedApplied addObject:@2];
        return o;
    }];
    [processor3 setPostProcessBlock:^id(id o) {
        [orderedApplied addObject:@3];
        return o;
    }];

    __unused Knight *knight = [_componentFactory componentForType:[Knight class]];
    NSArray *expected = @[
        @3,
        @2,
        @1
    ];
    XCTAssertEqualObjects(orderedApplied, expected);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Inject properties

- (void)test_injectProperties
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest)];
    }]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

    Knight *knight = [[Knight alloc] init];
    [_componentFactory inject:knight];

    XCTAssertNotNil(knight.quest);

}

- (void)test_injectProperties_subclassing
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest)];
    }]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CavalryMan class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(hitRatio) with:@(3.0f)];
    }]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"]];

    CavalryMan *cavalryMan = [[CavalryMan alloc] init];
    [_componentFactory inject:cavalryMan];

    XCTAssertNil(cavalryMan.quest);
    XCTAssertEqual(cavalryMan.hitRatio, 3.0f);

    Knight *knight = [[Knight alloc] init];
    [_componentFactory inject:knight];

    XCTAssertNotNil(knight.quest);
}

- (void)test_load_isLoad
{
    [_componentFactory load];
    XCTAssertTrue([_componentFactory isLoaded]);
}

- (void)test_unload_isLoad
{
    [_componentFactory load];
    [_componentFactory unload];
    XCTAssertFalse([_componentFactory isLoaded]);
}

- (void)test_registery_isLoad
{
    [_componentFactory registry];
    XCTAssertTrue([_componentFactory isLoaded]);
}

//TODO: This test can't be done with new API, because of restriction of OCMockito
//- (void)test_load_post_processors
//{
//    TyphoonDefinition *quest = [TyphoonDefinition withClass:[CampaignQuest class] key:@"quest"];
//    [_componentFactory registerDefinition:quest];
//    id <TyphoonDefinitionPostProcessor> postProcessor = mockProtocol(@protocol(TyphoonDefinitionPostProcessor));
//    [_componentFactory attachPostProcessor:postProcessor];
//    [_componentFactory load];
//    [_componentFactory load]; // Should do nothing
//    TyphoonDefinition *replacement = nil;
//    [verifyCount(postProcessor, times(1)) postProcessDefinition:quest replacement:&replacement withFactory:_componentFactory];
//}


- (void)test_load_singleton
{
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CampaignQuest class]
                                                         configuration:^(TyphoonDefinition *definition) {
            [definition setScope:TyphoonScopeSingleton];
        }]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopeLazySingleton];
    }]];
    [_componentFactory registerDefinition:[TyphoonDefinition withClass:[CavalryMan class] configuration:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopeObjectGraph];
    }]];
    [_componentFactory load];
    XCTAssertEqual([[_componentFactory singletons] count], 1);
}

- (void)test_load_weakSingleton
{
    TyphoonComponentFactory *localFactory = [[TyphoonComponentFactory alloc] init];
    NSString *key = @"WeakSingleton";

    [localFactory registerDefinition:[TyphoonDefinition withClass:[NSMutableString class] configuration:^(TyphoonDefinition *definition) {
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
        XCTAssertEqual(object1, object2);

        [object1 appendString:@"Hello"];
    }

    weakRef = object2;
    unsafeRef = object2;

    object1 = nil;
    object2 = nil;

    XCTAssertNil(weakRef);

    @autoreleasepool {
        object1 = [localFactory componentForKey:key];
    }

    XCTAssertTrue([object1 rangeOfString:@"Hello"].location == NSNotFound);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Definition Inheritance

//TODO: Move this test to TyphoonDefinitionTests
- (void)test_child_missing_initializer_inherits_parent_initializer_by_definition
{
    TyphoonDefinition
        *parentDefinition = [self registerParentDefinitionWithClass:[ClassWithConstructor class] initializerString:@"parentArgument"];
    TyphoonDefinition
        *childDefinition = [TyphoonDefinition withClass:[ClassWithConstructor class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = parentDefinition;
    }];
    [_componentFactory registerDefinition:childDefinition];

    ClassWithConstructor *child = [_componentFactory newOrScopeCachedInstanceForDefinition:childDefinition args:nil];

    XCTAssertEqual([child string], @"parentArgument");
}

//TODO: Move this test to TyphoonDefinitionTests
- (void)test_child_initializer_overrides_parent_initializer_by_definition
{
    TyphoonDefinition
        *parentDefinition = [self registerParentDefinitionWithClass:[ClassWithConstructor class] initializerString:@"parentArgument"];
    TyphoonDefinition *childDefinition =
        [self registerChildDefinitionWithClass:[ClassWithConstructor class] parentDefinition:parentDefinition
                             initializerString:@"childArgument"];

    ClassWithConstructor *child = [_componentFactory newOrScopeCachedInstanceForDefinition:childDefinition args:nil];

    XCTAssertEqual([child string], @"childArgument");
}

//TODO: Move this test to TyphoonDefinitionTests
- (void)test_child_initializer_overrides_parent_initializer_by_ref
{
    [self registerParentDefinitionWithClass:[ClassWithConstructor class] key:@"parentRef" initializerString:@"parentArgument"];
    TyphoonDefinition *childDefinition =
        [self registerChildDefinitionWithClass:[ClassWithConstructor class] parentRef:@"parentRef" initializerString:@"childArgument"];

    ClassWithConstructor *child = [_componentFactory newOrScopeCachedInstanceForDefinition:childDefinition args:nil];

    XCTAssertEqual([child string], @"childArgument");
}


- (void)test_prevents_instantiation_of_abstract_definition
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[NSURL class] configuration:^(TyphoonDefinition *definition) {
        definition.key = @"anAbstractDefinition";
        definition.abstract = YES;
    }];

    [_componentFactory registerDefinition:definition];

    @try {
        __unused NSURL *url = [_componentFactory componentForKey:@"anAbstractDefinition"];
        XCTFail(@"Should've thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects([e description], @"Attempt to instantiate abstract definition: TyphoonDefinition: class='NSURL', key='anAbstractDefinition', scope='ObjectGraph'");
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Test Utility Methods

- (TyphoonDefinition *)registerParentDefinitionWithClass:(Class)pClass initializerString:(NSString *)string
{
    TyphoonDefinition *parentDefinition = [TyphoonDefinition withClass:pClass key:nil];

    [parentDefinition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:string];
    }];

    [_componentFactory registerDefinition:parentDefinition];

    return parentDefinition;
}

- (TyphoonDefinition *)registerParentDefinitionWithClass:(Class)pClass key:(NSString *)key initializerString:(NSString *)string
{
    TyphoonDefinition *parentDefinition = [TyphoonDefinition withClass:pClass key:key];

    [parentDefinition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:string];
    }];

    [_componentFactory registerDefinition:parentDefinition];

    return parentDefinition;
}

- (TyphoonDefinition *)registerChildDefinitionWithClass:(Class)pClass parentDefinition:(TyphoonDefinition *)parentDefinition
                                      initializerString:(NSString *)string
{
    return [self registerChildDefinitionWithClass:pClass parentDefinition:parentDefinition parentRef:nil initializerString:string];
}

- (TyphoonDefinition *)registerChildDefinitionWithClass:(Class)pClass parentRef:(NSString *)parentRef initializerString:(NSString *)string
{
    return [self registerChildDefinitionWithClass:pClass parentDefinition:nil parentRef:parentRef initializerString:string];
}

- (TyphoonDefinition *)registerChildDefinitionWithClass:(Class)pClass parentDefinition:(TyphoonDefinition *)parentDefinition
                                              parentRef:(NSString *)parentRef initializerString:(NSString *)string
{
    TyphoonDefinition *childDefinition = [TyphoonDefinition withClass:pClass configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:string];
        }];
        if (parentDefinition) {
            definition.parent = parentDefinition;
        }
        else if (parentRef) {
            definition.parent = [TyphoonDefinition withClass:[TyphoonDefinition class] key:parentRef];
        }

    }];
    [_componentFactory registerDefinition:childDefinition];

    return childDefinition;
}


@end
