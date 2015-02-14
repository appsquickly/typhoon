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

#import "TyphoonConfigAssembly.h"
#import "TyphoonDefinition.h"
#import "Knight.h"
#import "TyphoonConfigPostProcessor.h"

@implementation TyphoonConfigAssembly

- (id)knight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:TyphoonConfig(@"damsels.rescued")];
    }];
}

- (id)anotherKnight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:TyphoonConfig(@"hasHorseWillTravel")];
    }];
}

@end