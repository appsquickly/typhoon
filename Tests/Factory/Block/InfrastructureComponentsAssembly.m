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

@implementation InfrastructureComponentsAssembly

- (id)propertyPlaceHolderConfigurer
{
  return [TyphoonDefinition propertyPlaceholderWithResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
}

- (id)knight
{
  return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
    [definition injectProperty:@selector(damselsRescued) withValueAsText:@"${damsels.rescued}"];
  }];
}

@end
