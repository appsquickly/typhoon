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
#import "SpringPropertyPlaceholderConfigurer.h"
#import "SpringBundleResource.h"

@interface SpringPropertyPlaceholderConfigurerTests : SenTestCase
@end

@implementation SpringPropertyPlaceholderConfigurerTests
{
    SpringPropertyPlaceholderConfigurer* _configurer;
}

- (void)setUp
{
    _configurer = [[SpringPropertyPlaceholderConfigurer alloc] init];
}

- (void)test_should_parse_property_name_value_pairs
{
    [_configurer usePropertyStyleResource:[SpringBundleResource withName:@"SomeProperties.properties"]];
    NSDictionary* properties = [_configurer properties];
    NSLog(@"Properties: %@", properties);

}

@end