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

@implementation MiddleAgesAssembly

- (id)knight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) with:[self defaultQuest]];
        [definition injectProperty:@selector(damselsRescued) with:[[self cavalryMan] property:@selector(damselsRescued)]];
        [definition setScope:TyphoonScopeObjectGraph];
    }];
}

- (id)cavalryMan
{
    return [TyphoonDefinition withClass:[CavalryMan class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) with:[self defaultQuest]];
        [definition injectProperty:@selector(damselsRescued) with:@(12)];
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)anotherKnight
{
    return [TyphoonDefinition withClass:[CavalryMan class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:hitRatio:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self defaultQuest]];
            [initializer injectParameterWith:@(13.75)];
        }];
        [definition injectProperty:@selector(hasHorseWillTravel) with:@YES];
    }];
}

- (id)yetAnotherKnight
{
    return [TyphoonDefinition withClass:[CavalryMan class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self defaultQuest]];
        }];
        [definition injectProperty:@selector(hitRatio) with:@(13.75)];
        [definition injectProperty:@selector(hasHorseWillTravel) with:@YES];
        [definition injectProperty:@selector(propertyInjectedAsInstance) with:@[
            @"foo",
            @"bar"
        ]];
    }];
}

- (id)knightWithCollections
{
    return [TyphoonDefinition withClass:[CavalryMan class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self defaultQuest]];
        }];

        [definition injectProperty:@selector(favoriteDamsels) with:@[
            @"Mary",
            @"Mary"
        ]];
        [definition injectProperty:@selector(friends) with:[NSSet setWithObjects:[self knight], [self anotherKnight], nil]];
        [definition injectProperty:@selector(friendsDictionary) with:@{
            @"knight" : [self knight],
            @"anotherKnight" : [self anotherKnight]
        }];
    }];
}

- (id)knightWithCollectionInConstructor
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:favoriteDamsels:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self defaultQuest]];
            [initializer injectParameterWith:@[
                @"Mary",
                @"Mary"
            ]];
        }];
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

- (id)serviceUrl
{
    return [TyphoonDefinition withClass:[NSURL class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(URLWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameter:@"string" with:@"http://dev.foobar.com/service/"];
        }];
    }];
}

- (id)swordFactory
{
    return [TyphoonDefinition withClass:[SwordFactory class]];
}

- (id)blueSword
{
    return [TyphoonDefinition withClass:[Sword class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(swordWithSpecification:) parameters:^(TyphoonMethod *initializer) {
            initializer.selector = @selector(swordWithSpecification:);
            [initializer injectParameter:@"specification" with:@"blue"];
        }];
        definition.factory = [self swordFactory];
    }];
}

- (id)knightWithRuntimeDamselsRescued:(NSNumber *)damselsRescued runtimeFoobar:(NSObject *)runtimeObject
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:damselsRescued];
        [definition injectProperty:@selector(foobar) with:runtimeObject];
    }];
}

/* Actually 'damselsRescued' replaced with InjectionWithRuntimeArgumentAtIndex(0) and url replaced with InjectionWithRuntimeArgumentAtIndex(1) */
- (id)knightWithRuntimeDamselsRescued:(NSNumber *)damselsRescued runtimeQuestUrl:(NSURL *)url
{    
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self questWithRuntimeUrl:url]];
        }];
        [definition injectProperty:@selector(damselsRescued) with:damselsRescued];
    }];
}

- (id)knightWithDefinedQuestUrl
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        id quest = [self questWithRuntimeUrl:[NSURL URLWithString:@"http://example.com"]];
        [definition injectProperty:@selector(quest) with:quest];
    }];
}

- (id)questWithRuntimeUrl:(NSURL *)url
{
    return [TyphoonDefinition withClass:[CampaignQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageUrl) with:url];
    }];
}

- (id)knightWithDamselsRescued:(NSNumber *)damselsRescued
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDamselsRescued:foo:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:damselsRescued];
            [initializer injectParameterWith:[self knightWithFoobarKnightWithDamselsRescued:damselsRescued]];
        }];
    }];
}

- (id)knightWithFoobarKnightWithDamselsRescued:(NSNumber *)damselsRescued
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:[self knightWithDamselsRescued:damselsRescued]];
    }];
}


- (id)knightWithPredefinedCircularDependency:(NSNumber *)damselsRescued
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDamselsRescued:foo:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:damselsRescued];
            [initializer injectParameterWith:[self knightWithFoobarKnightWithPredefinedCircularDependency]];
        }];
    }];
}

- (id)knightWithFoobarKnightWithPredefinedCircularDependency
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:[self knightWithPredefinedCircularDependency:@25]];
    }];
}

- (id)knightClassMethodInit
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(knightWithDamselsRescued:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@(13)];
        }];
    }];
}

- (id)knightWithMethodInjection
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setQuest:andDamselsRescued:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self defaultQuest]];
            [method injectParameterWith:@321];
        }];
    }];
}

@end