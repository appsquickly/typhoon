////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Typhoon/TyphoonDefinition.h>
#import "ObjectGraphAssembly.h"
#import "Knight.h"
#import "Fort.h"
#import "CampaignQuest.h"


@implementation ObjectGraphAssembly

- (id)objectGraphKnight
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(homeFort) withDefinition:[self objectGraphFort]];
        [definition injectProperty:@selector(quest) withDefinition:[self objectGraphQuest]];
    }];
}

- (id)objectGraphFort
{
    return [TyphoonDefinition withClass:[Fort class]];
}

- (id)objectGraphQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(fort) withDefinition:[self objectGraphFort]];
    }];
}

/* ====================================================================================================================================== */

- (id)prototypeKnight
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(homeFort) withDefinition:[self prototypeFort]];
        [definition injectProperty:@selector(quest) withDefinition:[self prototypeQuest]];
        [definition setScope:TyphoonScopePrototype];
    }];
}

- (id)prototypeFort
{
    return [TyphoonDefinition withClass:[Fort class] properties:^(TyphoonDefinition* definition)
    {
        [definition setScope:TyphoonScopePrototype];
    }];
}

- (id)prototypeQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(fort) withDefinition:[self prototypeFort]];
        [definition setScope:TyphoonScopePrototype];
    }];
}

@end