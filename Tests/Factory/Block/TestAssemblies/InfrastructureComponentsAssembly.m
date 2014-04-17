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

#import "InfrastructureComponentsAssembly.h"
#import "Typhoon.h"
#import "Knight.h"
#import "NSNullTypeConverter.h"
#import "TyphoonInjections.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"

@implementation InfrastructureComponentsAssembly

- (id)propertyPlaceHolderConfigurer
{
    return [TyphoonDefinition configDefinitionWithResources:@[
        [TyphoonBundleResource withName:@"SomeProperties.properties"],
        [TyphoonBundleResource withName:@"SomeOtherProperties.properties"]
    ]];
}

- (id)knight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(damselsRescued) with:TyphoonConfig(@"damsels.rescued")];
        [definition injectProperty:@selector(hasHorseWillTravel) with:TyphoonConfig(@"has.horse.will.travel")];
    }];
}

- (id)typeConverter
{
    return [TyphoonDefinition withClass:[NSNullTypeConverter class]];
}

@end
