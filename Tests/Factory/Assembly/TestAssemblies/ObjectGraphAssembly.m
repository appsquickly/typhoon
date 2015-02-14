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



#import "TyphoonDefinition.h"
#import "ObjectGraphAssembly.h"
#import "Knight.h"
#import "Fort.h"
#import "CampaignQuest.h"


@implementation ObjectGraphAssembly

- (id)objectGraphKnight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(homeFort) with:[self objectGraphFort]];
        [definition injectProperty:@selector(quest) with:[self objectGraphQuest]];
    }];
}

- (id)objectGraphFort
{
    return [TyphoonDefinition withClass:[Fort class]];
}

- (id)objectGraphQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(fort) with:[self objectGraphFort]];
    }];
}

//-------------------------------------------------------------------------------------------

- (id)prototypeKnight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(homeFort) with:[self prototypeFort]];
        [definition injectProperty:@selector(quest) with:[self prototypeQuest]];
        [definition setScope:TyphoonScopePrototype];
    }];
}

- (id)prototypeFort
{
    return [TyphoonDefinition withClass:[Fort class] configuration:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopePrototype];
    }];
}

- (id)prototypeQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(fort) with:[self prototypeFort]];
        [definition setScope:TyphoonScopePrototype];
    }];
}

@end