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

#import "InfrastructureComponentsAssembly.h"
#import "Typhoon.h"
#import "Knight.h"
#import "NSNullTypeConverter.h"
#import "TyphoonInjections.h"
#import "TyphoonConfigPostProcessor.h"

@implementation InfrastructureComponentsAssembly

- (id)propertyPlaceHolderConfigurer
{
    return [TyphoonDefinition withClass:[TyphoonConfigPostProcessor class]  configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceWithName:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:@"SomeProperties.properties"];
        }];
        [definition injectMethod:@selector(useResourceWithName:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:@"SomeOtherProperties.properties"];
        }];
    }];
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
