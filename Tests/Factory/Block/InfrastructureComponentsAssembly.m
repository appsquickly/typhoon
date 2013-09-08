//
//  InfrastructureComponentsAssembly.m
//  Tests
//
//  Created by Erik Sundin on 9/7/13.
//
//

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
