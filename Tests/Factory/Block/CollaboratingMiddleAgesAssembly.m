////////////////////////////////////////////////////////////////////////////////
//
//  58 NORTH
//  Copyright 2013 58 North
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of 58 North
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////

#import "CollaboratingMiddleAgesAssembly.h"
#import "MiddleAgesAssembly.h"
#import "TyphoonCollaboratingAssemblyProxy.h"
#import "TyphoonDefinition.h"
#import "Knight.h"


@implementation CollaboratingMiddleAgesAssembly

+ (instancetype)assembly
{
    CollaboratingMiddleAgesAssembly* assembly = [super assembly];
    [assembly setQuests:[TyphoonCollaboratingAssemblyProxy proxy]];
    return assembly;
}

- (id)knightWithExternalQuest
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(quest) withDefinition:[_quests environmentDependentQuest]];
    }];
}


@end