//
//  PrototypeAssembly.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 28/05/2018.
//  Copyright © 2018 typhoonframework.org. All rights reserved.
//

#import "PrototypeAssembly.h"
#import "Fort.h"
#import "King.h"
#import "Kingdom.h"

@implementation PrototypeAssembly

- (Knight *)prototypeKnight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopePrototype;
    }];
}

- (Knight *)prototypeKnightWithFort
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopePrototype;
        [definition injectProperty:@selector(homeFort) with:[self homeFort]];
    }];
}

- (id)homeFort
{
    return [TyphoonDefinition withClass:[Fort class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(owner) with:[self prototypeKnightWithFort]];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Complex prototype object graph
//-------------------------------------------------------------------------------------------

- (Knight *)generalKnight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopePrototype;
        [definition injectProperty:@selector(kingdom) with:[self kingdom]];
    }];
}

- (King *)kingArthur
{
    return [TyphoonDefinition withClass:[King class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeLazySingleton;
        [definition injectProperty:@selector(name) with:@"Arthur"];
        [definition injectProperty:@selector(personalGuard) with:[self generalKnight]];
    }];
}

- (Kingdom *)kingdom
{
    return [TyphoonDefinition withClass:[Kingdom class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeLazySingleton;
        [definition injectProperty:@selector(name) with:@"Lloegyr"];
        [definition injectProperty:@selector(first) with:[self kingArthur]];
        [definition injectProperty:@selector(second) with:[self kingMordred]];
    }];
}

- (King *)kingMordred
{
    return [TyphoonDefinition withClass:[King class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeLazySingleton;
        [definition injectProperty:@selector(name) with:@"Mordred"];
        [definition injectProperty:@selector(personalGuard) with:[self generalKnight]];
    }];
}

@end
