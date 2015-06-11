////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import "TyphoonFactoryDefinition.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "Knight.h"
#import "CavalryMan.h"
#import "CampaignQuest.h"
#import "Quest.h"
#import "TyphoonAssembly.h"

//-------------------------------------------------------------------------------------------
#pragma mark - Factories
//-------------------------------------------------------------------------------------------

@interface KnightFactory : NSObject

@property (nonatomic) CGFloat defaultHitRatio;

- (Knight *)knight;

@end

@implementation KnightFactory

- (Knight *)knight
{
    CavalryMan *cavalery = [[CavalryMan alloc] init];
    cavalery.hitRatio = self.defaultHitRatio;
    return cavalery;
}

@end

@interface QuestFactory : NSObject

- (id<Quest>)quest;

@end

@implementation QuestFactory

- (id<Quest>)quest
{
    return [[CampaignQuest alloc] init];
}


@end

//-------------------------------------------------------------------------------------------
#pragma mark - Assembly
//-------------------------------------------------------------------------------------------

@interface FactoriesAssembly: TyphoonAssembly

- (Knight *)createKnight;

- (KnightFactory *)knightsFactoryWithDefaultHitRatio:(NSNumber *)hitRatio;

@end

@implementation FactoriesAssembly

- (Knight *)createKnight
{
    return [TyphoonDefinition withFactory:[self knightsFactoryWithDefaultHitRatio:@3.5] selector:@selector(knight)];
}

- (KnightFactory *)knightsFactoryWithDefaultHitRatio:(NSNumber *)hitRatio
{
    return [TyphoonDefinition withClass:[KnightFactory class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(defaultHitRatio) with:hitRatio];
        [definition setScope:TyphoonScopeLazySingleton];
    }];
}


@end

//-------------------------------------------------------------------------------------------
#pragma mark - Tests
//-------------------------------------------------------------------------------------------

@interface TyphoonFactoryDefinitionTests : XCTestCase
@end


@implementation TyphoonFactoryDefinitionTests



- (void)test_isCandidateForAutoInjectedClass
{
    TyphoonDefinition *factory = [TyphoonDefinition withClass:[KnightFactory class]];

    TyphoonFactoryDefinition *definition = [TyphoonDefinition withFactory:factory selector:@selector(knight)];
    definition.classOrProtocolForAutoInjection = [CavalryMan class];
    XCTAssertFalse([definition isCandidateForInjectedClass:[CampaignQuest class] includeSubclasses:NO]);
    XCTAssertFalse([definition isCandidateForInjectedClass:[Knight class] includeSubclasses:NO]);
    XCTAssertTrue([definition isCandidateForInjectedClass:[Knight class] includeSubclasses:YES]);
}

- (void)test_isCandidateForAutoInjectedProtocol
{
    TyphoonDefinition *factory = [TyphoonDefinition withClass:[QuestFactory class]];

    TyphoonFactoryDefinition *definition = [TyphoonDefinition withFactory:factory selector:@selector(quest)];
    definition.classOrProtocolForAutoInjection = @protocol(Quest);

    XCTAssertFalse([definition isCandidateForInjectedProtocol:@protocol(NSObject)]);
    XCTAssertTrue([definition isCandidateForInjectedProtocol:@protocol(Quest)]);

    definition.classOrProtocolForAutoInjection = [CampaignQuest class];
    XCTAssertTrue([definition isCandidateForInjectedProtocol:@protocol(Quest)]);

}

- (void)test_factory_definition_with_runtime_argument
{
    FactoriesAssembly *assembly = [FactoriesAssembly new];
    [assembly activate];

    CavalryMan *knight = (CavalryMan *)[assembly createKnight];

    XCTAssertNotNil(knight);
    XCTAssertEqual(knight.hitRatio, 3.5f);

    XCTAssertTrue([assembly knightsFactoryWithDefaultHitRatio:@3.5f] == [assembly knightsFactoryWithDefaultHitRatio:@3.5f]);
}


@end