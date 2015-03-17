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


@interface KnightFactory : NSObject

- (Knight *)knight;

@end

@implementation KnightFactory

- (Knight *)knight
{
    return [[CavalryMan alloc] init];
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


@end