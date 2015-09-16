////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
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
    CollaboratingMiddleAgesAssembly *strongSelf = self;
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) with:[strongSelf->_quests environmentDependentQuest]];
    }];
}

- (id)knightWithCollaboratingFoobar:(NSString *)foobar
{
    CollaboratingMiddleAgesAssembly *strongSelf = self;
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(friends) with:[NSSet setWithObject:[strongSelf->_quests knightWithFoobar:foobar]]];
    }];
}

@end
