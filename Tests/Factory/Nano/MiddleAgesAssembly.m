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



#import <objc/runtime.h>
#import "MiddleAgesAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+BlockBuilders.h"
#import "Knight.h"
#import "TyphoonInitializer.h"
#import "CampaignQuest.h"


@implementation MiddleAgesAssembly

- (id)basicKnight
{
    return [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectParameterAtIndex:0 withDefinition:[self defaultQuest]];
    }];
}

- (id)defaultQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class]];
}

@end