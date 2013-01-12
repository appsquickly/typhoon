////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "Spring.h"
#import "Knight.h"

@interface SpringPropertyPlaceholderConfigurerTests : SenTestCase
@end

@implementation SpringPropertyPlaceholderConfigurerTests
{
    SpringPropertyPlaceholderConfigurer* _configurer;
}

- (void)setUp
{
    _configurer = [[SpringPropertyPlaceholderConfigurer alloc] init];
    [_configurer usePropertyStyleResource:[SpringBundleResource withName:@"SomeProperties.properties"]];
}

- (void)test_parses_property_name_value_pairs
{
    NSDictionary* properties = [_configurer properties];
    NSLog(@"Properties: %@", properties);
}

- (void)test_mutates_property_values
{
    SpringComponentFactory* factory = [[SpringComponentFactory alloc] init];
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"damselsRescued" withValueAsText:@"${damsels.rescued}"];
    [factory register:knightDefinition];

    [_configurer mutateComponentDefinitionsIfRequired:[factory registry]];

    Knight* knight = [factory componentForType:[Knight class]];
    assertThatInt(knight.damselsRescued, equalToInt(12));

}

@end