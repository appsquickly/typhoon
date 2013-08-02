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
#import "SwordFactory.h"
#import "Sword.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "Moat.h"
#import "Castle.h"

@implementation MiddleAgesAssembly

- (id)knight
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(quest) withDefinition:[self defaultQuest]];
        [definition injectProperty:@selector(damselsRescued) withValueAsText:@"12"];
        [definition setScope:TyphoonScopeDefault];
    }];
}

- (id)cavalryMan
{
    return [TyphoonDefinition withClass:[CavalryMan class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(quest) withDefinition:[self defaultQuest]];
        [definition injectProperty:@selector(damselsRescued) withValueAsText:@"12"];
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)anotherKnight
{
    return [TyphoonDefinition withClass:[CavalryMan class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:hitRatio:);
        [initializer injectWithDefinition:[self defaultQuest]];
        [initializer injectWithValueAsText:@"13.75"];

    } properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(hasHorseWillTravel) withValueAsText:@"YES"];

    }];
}

- (id)yetAnotherKnight
{
    return [TyphoonDefinition withClass:[CavalryMan class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectWithDefinition:[self defaultQuest]];

    } properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(hitRatio) withValueAsText:@"13.75"];
        [definition injectProperty:@selector(hasHorseWillTravel) withValueAsText:@"YES"];

    }];
}

- (id)knightWithCollections
{
    return [TyphoonDefinition withClass:[CavalryMan class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectWithDefinition:[self defaultQuest]];

    } properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(favoriteDamsels) asCollection:^(TyphoonPropertyInjectedAsCollection* collection)
        {
            [collection addItemWithText:@"Mary" requiredType:[NSString class]];
            [collection addItemWithText:@"Mary" requiredType:[NSString class]];
        }];

        [definition injectProperty:@selector(friends) asCollection:^(TyphoonPropertyInjectedAsCollection* collection)
        {
            [collection addItemWithDefinition:[self knight]];
            [collection addItemWithDefinition:[self anotherKnight]];
        }];
    }];
}

- (id)defaultQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class]];
}

- (id)serviceUrl;
{
    return [TyphoonDefinition withClass:[NSURL class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(URLWithString:);
        [initializer injectParameterNamed:@"string" withValueAsText:@"http://dev.foobar.com/service/" requiredTypeOrNil:[NSString class]];
    }];
}

- (id)swordFactory
{
    return [TyphoonDefinition withClass:[SwordFactory class]];
}

- (id)blueSword
{
    return [TyphoonDefinition withClass:[Sword class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(swordWithSpecification:);
        [initializer injectParameterNamed:@"specification" withValueAsText:@"blue" requiredTypeOrNil:[NSString class]];
    } properties:^(TyphoonDefinition* definition)
    {
        definition.factory = [self swordFactory];
    }];
}

- (id)estateWithCastle:(id)castle
{
    return [TyphoonDefinition withClass:[Estate class] initialization:^(TyphoonInitializer *initializer) ] {
        initializer.selector = @selector(initWithCastle:);
        
        id aMoat = [self moatFilledWithLava]; // actually a definition. what to do here?
        [initializer injectWithDefinition:[self castleWithMoat:aMoat]]; // later - or definition
        
        id aMoat = [[Moat alloc] init]; // ugly. don't encourage this? or allow it?
        [initializer injectWithDefinition:[self castleWithMoat:aMoat]]; // later - or definition
    }];
}

// don't call from other definitions
- (id)castleWithMoat:(id)theMoat;
{
    return [TyphoonDefinition withClass:[Castle class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithMoat:);
        
        [initializer injectWithRuntimeObject:theMoat]; // later - or definition
    }];
}

- (id)moatFilledWithWater;
{
    return [TyphoonDefinition withClass:[Moat class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(filledWith) withValueAsText:@"Water"];
    }];
}

- (id)moatFilledWithLava;
{
    return [TyphoonDefinition withClass:[Moat class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(filledWith) withValueAsText:@"Lava"];
    }];
    
//    return [self moatFilledWith:@"Lava"];
// return [self moatFilledWith:[self lava]]; // allows only one moatFilledWith: definition, parameterized by the liquid. say we have two different liquids. this is three method definitions for four object configurations.
// lava, water, lava castle, water castle
    
    // compare to lacking parameters like this:
    // you need four definitions for four object configurations, and seperate ones for lava castle and water castle.
    // you should still have a seperate lava castle and water castle exposed outwards, but internally, you can deduplicate via parameters.
}

- (id)lava;
{
    //
}

- (id)moatFilledWith:(NSString *)aLiquid;
{
    return [TyphoonDefinition withClass:[Moat class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(filledWith) withRuntimeObject:aLiquid];
        [definition injectProperty:@selector(filledWith2) withRuntimeObject:anotherLiquid];
    }];
}

@end