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