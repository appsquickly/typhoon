////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "ExtendedMiddleAgesAssembly.h"
#import "Knight.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "CampaignQuest.h"
#import "TyphoonInjections.h"

@implementation ExtendedMiddleAgesAssembly

- (id)yetAnotherKnight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:@(296000)];
    }];
}

- (id)environmentDependentQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageUrl) with:[NSURL URLWithString:@"www.foobar.com/quest"]];
    }];
}

@end