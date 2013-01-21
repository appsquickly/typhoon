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
    }];
}

- (id)cavalryMan
{
    return [TyphoonDefinition withClass:[CavalryMan class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@"quest" withDefinition:[self defaultQuest]];
        [definition injectProperty:@"damselsRescued" withValueAsText:@"12"];
    }];
}

- (id)defaultQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class]];
}

@end