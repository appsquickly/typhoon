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
#import "MediocreQuest.h"
#import "DamselQuest.h"
#import "Typhoon.h"
#import "CavalryMan.h"
#import "SwordFactory.h"
#import "Mock.h"
#import "TyphoonInject.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "RectModel.h"
#import "PrimitiveMan.h"
#import "DummyQuest.h"

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

- (id)boringQuest
{
    return [TyphoonDefinition withClass:[MediocreQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageUrl) with:[NSURL URLWithString:@"http://boring.com"]];
    }];
}

- (id)damselQuest
{
    return [TyphoonDefinition withClass:[DamselQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(bounty) with:@(10000)];
    }];
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

- (id)knightWithMethodInjectionSingleArgumentQuest
{
    return [TyphoonDefinition withClass:[DummyQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageUrl) with:[NSURL URLWithString:@"http://appsquick.ly"]];
        [definition injectMethod:@selector(setContext:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self knightWithMethodInjectionSingleArgument]];
        }];
    }];
}

- (id)knightWithMethodInjectionSingleArgument
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setFavoriteQuest:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self knightWithMethodInjectionSingleArgumentQuest]];
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

- (Mock *)mockWithRuntimeBlock:(NSString *(^)(void))block andRuntimeClass:(Class)aClass
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

- (Mock *)mockWithRuntimeBlock:(NSString *(^)(void))block
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

- (id)knightWithQuest:(id <Quest>)quest {
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) with:quest];
    }];
}

- (id)nullQuest
{
    return [TyphoonDefinition with:nil];
}

- (id)knightWithNullQuest
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) with:[self nullQuest]];
    }];
}

- (NSNumber *)simpleNumber
{
    return [TyphoonDefinition with:@(1)];
}

- (NSString *)simpleString
{
    return [TyphoonDefinition with:@"123"];
}

- (NSString *(^)(void))blockDefinition
{
    return [TyphoonDefinition with:^NSString *(void){
        return @"321";
    }];
}

- (NSString *)referenceToSimpleString
{
    return [TyphoonDefinition with:[self simpleString]];
}

- (NSArray *)simpleArray
{
    return [TyphoonDefinition with:@[[self simpleString], [self referenceToSimpleString], @"123"]];
}

- (id)simpleRuntimeArgument:(id)argument
{
    return [TyphoonDefinition with:argument];
}

- (id)occasionallyNilKnightWithBeforeInjections
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initNilInstance)];
        [definition performBeforeInjections:@selector(favoriteQuest)];
    }];
}

- (id)occasionallyNilKnightWithAfterInjections
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initNilInstance)];
        [definition performAfterInjections:@selector(favoriteQuest)];
    }];
}

- (id)occasionallyNilKnightWithMethodInjections
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initNilInstance)];
        [definition injectMethod:@selector(setDamselsRescued:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:@42];
        }];
    }];
}

- (id)blockSingletonKnight
{
    return [TyphoonBlockDefinition withClass:[Knight class] initializer:^id{
        return [[Knight alloc] initWithQuest:[self defaultQuest]];

    } injections:^(Knight *knight) {
        knight.damselsRescued = 42;
        [knight setFoobar:@(123) andHasHorse:YES friends:nil];

    } configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeWeakSingleton;
    }];
}

- (CampaignQuest *)blockQuest
{
    return [self blockQuestWithURL:[NSURL URLWithString:@"https://foo.bar"]];
}

- (CampaignQuest *)blockQuestWithURL:(NSURL *)URL
{
    return [TyphoonBlockDefinition withClass:[CampaignQuest class] block:^id{
        return [[CampaignQuest alloc] initWithImageUrl:URL];
    }];
}

- (id)blockKnightCallingMethodsOnDefinitions
{
    return [TyphoonBlockDefinition withClass:[Knight class] block:^id{
        Knight *knight = [[Knight alloc] init];
        knight.foobar = [self blockQuest].imageUrl;
        knight.damselsRescued = [self simpleNumber].unsignedIntegerValue;
        return knight;
    }];
}

- (id)blockKnightWithFavoriteDamsels:(NSArray *)favoriteDamsels questURL:(NSURL *)questURL
{
    return [TyphoonBlockDefinition withClass:[Knight class] block:^id{
        Knight *knight = [[Knight alloc] init];
        knight.favoriteDamsels = favoriteDamsels;
        knight.quest = [self blockQuestWithURL:questURL];
        return knight;
    }];
}

// This is no longer supported. And it's impossible to support with latest changes to Core. (at least at this stage)
//- (id)blockKnightWithPrimitiveDamsels:(NSUInteger)damsels
//{
//    return [TyphoonBlockDefinition withClass:[Knight class] block:^id{
//        Knight *knight = [[Knight alloc] init];
//        knight.damselsRescued = damsels;
//        return knight;
//    }];
//}

- (id)blockKnightWithQuestsByType
{
    return [TyphoonBlockDefinition withBlock:^id{
        Knight *knight = [[Knight alloc] init];
        knight.quest = [MediocreQuest typhoonInjectByType];
        [knight setFavoriteQuest:[TyphoonInject byType:@protocol(RescueQuest)]];
        return knight;
    }];
}

- (id)blockKnightWithoutInitializer
{
    return [TyphoonBlockDefinition withClass:[Knight class] injections:^(Knight *instance) {
        instance.damselsRescued = 12;
    }];
}

- (id)blockKnightWithCircularDependency
{
    return [TyphoonBlockDefinition withInitializer:^id{
        return [[Knight alloc] initWithDamselsRescued:123 foo:nil];

    } injections:^(Knight *instance) {
        instance.quest = [self blockQuestForKnightWithCircularDependency];
    }];
}

- (id)blockQuestForKnightWithCircularDependency
{
    return [TyphoonBlockDefinition withInitializer:^id{
        return [[DamselQuest alloc] init];

    } injections:^(DamselQuest *instance) {
        instance.bounty = ((Knight *)[self blockKnightWithCircularDependency]).damselsRescued;
    }];
}

- (id)knightWithBlockQuestWithURL:(NSURL *)questURL
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self blockQuestWithURL:questURL]];
        }];
    }];
}

- (id)notSoBlockKnight
{
    return [TyphoonBlockDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self blockQuest]];
        }];
        [definition injectProperty:@selector(damselsRescued) with:@(12)];
    }];
}

- (id)rectModel
{
    return [TyphoonDefinition withClass:[RectModel class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(rectFrame) with:[self mainScreenBounds]];
    }];
}


- (PrimitiveMan *)mainScreen
{
    return [TyphoonDefinition withFactory:[PrimitiveMan class] selector:@selector(new)];
}

- (NSValue *)mainScreenBounds
{
    return [TyphoonDefinition withFactory:[self mainScreen] selector:@selector(makeRect)];
}

- (NSNumber *)doublePrimitive
{
    return [TyphoonDefinition withFactory:@(123.32) selector:@selector(doubleValue)];
    
}

@end
