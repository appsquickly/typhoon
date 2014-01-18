////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "CollaboratingMiddleAgesAssembly.h"
#import "TyphoonDefinition.h"
#import "Knight.h"
#import "OCLogTemplate.h"
#import "CampaignQuest.h"


@implementation CollaboratingMiddleAgesAssembly

- (id)knightWithExternalQuest
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(quest) withDefinition:[_quests environmentDependentQuest]];
    }];
}

+ (void)verifyKnightWithExternalQuest:(Knight*)knight
{
    LogTrace(@"Knight: %@", knight);

    if (!knight) {
        [NSException raise:NSInternalInconsistencyException format:@"Expected a non-nil knight, but got nil."];
    }
//    assertThat(knight, notNilValue()); // this needs to call into a SenTestCase, not being self. Perhaps provide when initializing the assembly, and then add a new macro to OCHamcrest?

    if (![knight.quest isKindOfClass:[CampaignQuest class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Expected a campaign quest to be provided to the knight, but was '%@'", knight.quest];
    }
    //assertThat(knight.quest, instanceOf([CampaignQuest class]));
}

@end