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

#import "PropertyPlaceholderAssembly.h"
#import "TyphoonDefinition.h"
#import "Knight.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"

@implementation PropertyPlaceholderAssembly

- (id)knight
{
    return [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
       [definition injectProperty:@selector(damselsRescued) with:TyphoonConfig(@"damsels.rescued")];
    }];
}

- (id)anotherKnight
{
    return [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:TyphoonConfig(@"hasHorseWillTravel")];
    }];
}

@end