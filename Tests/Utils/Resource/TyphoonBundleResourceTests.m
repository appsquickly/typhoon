////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonResource.h"
#import "TyphoonBundleResource.h"

@interface TyphoonBundleResourceTests : SenTestCase
@end

@implementation TyphoonBundleResourceTests

- (void)test_returns_bundle_resource_as_string
{
    id <TyphoonResource> resource = [TyphoonBundleResource withName:@"MiddleAgesAssembly.xml"];
    NSString* resourceString = [resource asString];
    assertThat(resourceString, notNilValue());
}

- (void)test_raises_exception_for_invalid_resource_name
{
    @try
    {
        id <TyphoonResource> resource = [TyphoonBundleResource withName:@"SomeResourceThatDoesNotExist.txt"];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Resource named 'SomeResourceThatDoesNotExist.txt' not in bundle."));
    }

}

@end