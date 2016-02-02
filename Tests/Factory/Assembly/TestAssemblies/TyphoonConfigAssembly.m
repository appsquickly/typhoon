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
#import "TyphoonBlockDefinition.h"
#import "Knight.h"
#import "TyphoonConfigPostProcessor.h"
#import "NSObject+TyphoonConfig.h"

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

- (id)blockKnight
{
    return [TyphoonBlockDefinition withClass:[Knight class] block:^id{
        Knight *knight = [[Knight alloc] init];
        knight.damselsRescued = [NSNumber typhoonForConfigKey:@"damsels.rescued"].unsignedIntegerValue;
        return knight;
    }];
}

@end
