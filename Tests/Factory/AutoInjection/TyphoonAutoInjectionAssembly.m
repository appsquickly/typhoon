//
// Created by Aleksey Garbarev on 12.09.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "TyphoonAutoInjectionAssembly.h"
#import "Quest.h"
#import "Knight.h"
#import "Fort.h"
#import "CampaignQuest.h"
#import "AutoInjectionKnight.h"

@implementation TyphoonAutoInjectionAssembly

- (id<Quest>)defaultQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class]];
}

- (Fort *)defaultFort
{
    return [TyphoonDefinition withClass:[Fort class]];
}

@end

@implementation TyphoonAutoInjectionAssemblyWithKnight

- (AutoInjectionKnight *)autoInjectedKnight
{
    return [TyphoonDefinition withClass:[AutoInjectionKnight class]];
}

@end