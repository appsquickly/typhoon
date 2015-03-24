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



#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "Typhoon.h"
#import "CavalryMan.h"
#import "SwordFactory.h"
#import "Mock.h"
#import "TyphoonInjections.h"
#import "CollaboratingMiddleAgesAssembly.h"

@implementation MiddleAgesAssembly

- (id)knight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) with:[self defaultQuest]];
        [definition injectProperty:@selector(favoriteDamsels) with:@[
            @"foo",
            @"bar"
        ]];
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
            [initializer injectParameterWith:@"http://dev.foobar.com/service/"];
        }];
    }];
}

- (id)swordFactory
{
    return [TyphoonDefinition withClass:[SwordFactory class]];
}

- (id)blueSword
{
    return [TyphoonDefinition withFactory:[self swordFactory] selector:@selector(swordWithSpecification:)
        parameters:^(TyphoonMethod *factoryMethod) {
            [factoryMethod injectParameterWith:@"blue"];
        }];
}

- (id)swordWithSpec:(NSString *)spec error:(NSValue *)error
{
    return [TyphoonDefinition withFactory:[self swordFactory] selector:@selector(swordWithSpecification:error:)
                               parameters:^(TyphoonMethod *factoryMethod) {
                                   [factoryMethod injectParameterWith:spec];
                                   [factoryMethod injectParameterWith:error];
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
        [definition injectProperty:@selector(foobar) with:[self knightWithPredefinedCircularDependency:damselsRescued]];
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

- (id)knightWithCircularDependencyAndDamselsRescued:(NSNumber *)damselsRescued
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
        [definition injectProperty:@selector(foobar) with:[self knightWithCircularDependencyAndDamselsRescued:damselsRescued]];
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

- (id)knightWithFoobar:(NSString *)foobar
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:foobar];
    }];
}

- (id)knightWithFakePropertyQuest
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(favoriteQuest) with:[self defaultQuest]];
    }];
}

- (id)knightWithFakePropertyQuestByType
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(favoriteQuest)];
    }];
}

- (Mock *)mockWithRuntimeBlock:(NSString *(^)())block andRuntimeClass:(Class)aClass
{
    return [TyphoonDefinition withClass:[Mock class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithObject:clazz:block:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:nil];
            [initializer injectParameterWith:aClass];
            [initializer injectParameterWith:block];
        }];
    }];
}

- (id)knightRuntimeArgumentsFromDefinition
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:[self urlWithString:[self predefinedUrlString]]];
    }];
}

- (NSURL *)urlWithString:(NSString *)string
{
    return [TyphoonDefinition withClass:[NSURL class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:string];
        }];
    }];
}

- (NSString *)predefinedUrlString
{
    return [TyphoonDefinition withClass:[NSString class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@"http://google.com"];
        }];
    }];
}

- (id)knightRuntimeArgumentsFromDefinitionWithRuntimeArg
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:[self urlWithString:[self stringWithValue:@"http://typhoonframework.org"]]];
    }];
}

- (NSString *)stringWithValue:(NSString *)value
{
    return [TyphoonDefinition withClass:[NSString class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:value];
        }];
    }];
}

- (NSString *)stringValueShortcut
{
    return [self stringWithValue:@"Hello world!"];
}

- (Mock *)mockWithRuntimeBlock:(NSString *(^)())block
{
    return [self mockWithRuntimeBlock:block andRuntimeClass:[NSString class]];
}

- (Mock *)mockWithRuntimeClass:(Class)clazz
{
    return [self mockWithRuntimeBlock:^NSString * {
        return @"Hello";
    } andRuntimeClass:clazz];
}

- (id)knightWithRuntimeQuestUrl:(NSURL *)url
{
    return [self knightWithRuntimeDamselsRescued:@(13) runtimeQuestUrl:url];
}

- (id)knightRuntimeArgumentsFromDefinitionsSetWithRuntimeArg
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(foobar) with:[self urlWithString:[self stringWithValue:[self stringWithValue:[self stringWithValue:@"http://example.com"]]]]];
    }];
}

- (id)knightWithPredefinedRuntimeQuest
{
    return [self knightWithRuntimeDamselsRescued:@(13) runtimeQuestUrl:[NSURL URLWithString:@"http://appsquick.ly"]];
}

@end