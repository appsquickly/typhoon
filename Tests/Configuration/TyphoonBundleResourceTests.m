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

#import <XCTest/XCTest.h>
#import "TyphoonResource.h"
#import "TyphoonBundleResource.h"
#import "OCLogTemplate.h"

@interface TyphoonBundleResourceTests : XCTestCase
@end

@implementation TyphoonBundleResourceTests

- (void)test_returns_bundle_resource_as_string
{
    id <TyphoonResource> resource = [TyphoonBundleResource withName:@"SomeProperties.properties"];
    NSString* resourceString = [resource asString];
    XCTAssertNotNil(resourceString);
}

- (void)test_returns_bundle_resource_without_type_as_string
{
    id <TyphoonResource> resource = [TyphoonBundleResource withName:@"SomeResource"];
    NSString* resourceString = [resource asString];
    XCTAssertNotNil(resourceString);
}

- (void)test_returns_bundle_resource_as_data
{
    id <TyphoonResource> resource = [TyphoonBundleResource withName:@"SomeResource"];
    NSData* data = [resource data];
    XCTAssertNotNil(data);
}

- (void)test_raises_exception_for_invalid_resource_name
{
    @try
    {
        id <TyphoonResource> resource = [TyphoonBundleResource withName:@"SomeResourceThatDoesNotExist.txt"];
        NSLog(@"Resource: %@", resource);
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        XCTAssertEqualObjects([e description], @"Resource named 'SomeResourceThatDoesNotExist.txt' not in bundle.");
    }

}

- (void)test_returns_url
{
    id <TyphoonResource> resource = [TyphoonBundleResource withName:@"SomeProperties.properties"];
    XCTAssertNotNil(resource.url);

    LogDebug(@"Url: %@", resource.url);
}

@end