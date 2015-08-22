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

#import "ConfigAssembly.h"
#import "TyphoonConfigPostProcessor.h"
#import "CavalryMan.h"
#import "Knight.h"
#import "TyphoonDefinition+Infrastructure.h"


@implementation ConfigAssembly

- (id)config
{
    return [TyphoonDefinition configDefinitionWithName:@"development_Config.plist"];
}

- (Knight *)configuredCavalryMan
{
    return [TyphoonDefinition withClass:[CavalryMan class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:TyphoonConfig(@"damsels.rescued")];
        definition.scope = TyphoonScopeSingleton;
    }];
}


@end