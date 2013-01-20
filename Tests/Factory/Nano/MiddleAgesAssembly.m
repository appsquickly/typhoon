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
#import "TyphoonComponentDefinition.h"
#import "TyphoonComponentDefinition+BlockBuilders.h"
#import "Knight.h"
#import "TyphoonComponentInitializer.h"
#import "CampaignQuest.h"


@implementation MiddleAgesAssembly


- (TyphoonComponentDefinition*)basicKnight
{
    return [TyphoonComponentDefinition withClass:[Knight class] initialization:^(TyphoonComponentInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectParameterAtIndex:0 withDefinition:[self defaultQuest]];
    }];
}

- (TyphoonComponentDefinition*)cavalryMan
{
    return nil;
}

- (TyphoonComponentDefinition*)defaultQuest
{
    return [TyphoonComponentDefinition withClass:[CampaignQuest class]];
}

@end