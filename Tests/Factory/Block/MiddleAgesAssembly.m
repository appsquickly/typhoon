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



#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "Typhoon.h"
#import "CavalryMan.h"
#import "SwordFactory.h"
#import "Sword.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonDefinition.h"
#import "TyphoonParameterInjectedAsCollection.h"

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
        [definition injectProperty:@selector(propertyInjectedAsInstance) withObjectInstance:@[@"foo", @"bar"]];
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

- (id)knightWithCollectionInConstructor
{
    return [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer) {
        initializer.selector = @selector(initWithQuest:favoriteDamsels:);
        [initializer injectWithDefinition:[self defaultQuest]];
        [initializer injectWithCollection:^(TyphoonParameterInjectedAsCollection *collection)
         {
             [collection addItemWithText:@"Mary" requiredType:[NSString class]];
             [collection addItemWithText:@"Jane" requiredType:[NSString class]];
             
         } requiredType:[NSArray class]];
    }];
}

- (id)defaultQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class]];
}

- (id)environmentDependentQuest
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

@end