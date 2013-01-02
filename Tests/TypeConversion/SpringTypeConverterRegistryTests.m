////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "SpringTypeConverterRegistry.h"
#import "SpringTypeDescriptor.h"
#import "NSObject+SpringReflectionUtils.h"
#import "SpringTypeConverter.h"
#import "SpringNSURLTypeConverter.h"
#import "SpringLogTemplate.h"


@interface SpringTypeConverterRegistryTests : SenTestCase

@property(nonatomic, strong) NSData* data;

@end

@implementation SpringTypeConverterRegistryTests
{
    SpringTypeConverterRegistry* _registry;
}

- (void)setUp
{
    _registry = [SpringTypeConverterRegistry shared];
}

- (void)test_raises_exception_when_converter_class_not_registered
{
    SpringTypeDescriptor* typeDescriptor = [self typeForPropertyWithName:@"data"];

    @try
    {
        id <SpringTypeConverter> converter = [[SpringTypeConverterRegistry shared] converterFor:typeDescriptor];
        SpringDebug(@"here's the converter: %@", converter);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"No type converter registered for type: 'NSData'."));
    }
}

- (void)test_raises_exception_when_converter_registered_more_than_once
{
    @try
    {
        SpringNSURLTypeConverter* converter = [[SpringNSURLTypeConverter alloc] init];
        [_registry register:converter forClassOrProtocol:[NSURL class]];
        STFail(@"SHould have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Converter for 'NSURL' already registered."));
    }

}

@end