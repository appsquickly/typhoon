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

//TODO: Test protocol matching
- (void)test_matchesAutoInjectionWithType_with_class
{
    TyphoonDefinition *factory = [TyphoonDefinition withClass:[KnightFactory class]];

    TyphoonFactoryDefinition *definition = [TyphoonDefinition withFactory:factory selector:@selector(knight)];
    definition.classOrProtocolForAutoInjection = [CavalryMan class];
    XCTAssertFalse([definition matchesAutoInjectionWithType:[CampaignQuest class] includeSubclasses:NO]);
    XCTAssertFalse([definition matchesAutoInjectionWithType:[Knight class] includeSubclasses:NO]);
    XCTAssertTrue([definition matchesAutoInjectionWithType:[Knight class] includeSubclasses:YES]);
}



@end