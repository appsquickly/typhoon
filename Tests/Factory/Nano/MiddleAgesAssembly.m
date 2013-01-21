////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "Typhoon.h"
#import "CavalryMan.h"
#import "TyphoonDefinition+BlockAssembly.h"


@implementation MiddleAgesAssembly

- (id)basicKnight
{
    return [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectWithDefinition:[self defaultQuest]];
    } properties:^(TyphoonDefinition* definition)
    {
        [definition setLifecycle:TyphoonComponentLifeCyclePrototype];
    }];
}

- (id)cavalryMan
{
    return [TyphoonDefinition withClass:[CavalryMan class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(quest) withDefinition:[self defaultQuest]];
        [definition injectProperty:@selector(damselsRescued) withValueAsText:@"12"];
    }];
}

- (id)defaultQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class]];
}

@end