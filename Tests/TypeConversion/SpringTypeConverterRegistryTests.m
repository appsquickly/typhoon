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


@interface SpringTypeConverterRegistryTests : SenTestCase

@property(nonatomic, strong) NSURL* url;

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
    SpringTypeDescriptor* typeDescriptor = [self typeForPropertyWithName:@"url"];

    @try
    {
        id <SpringTypeConverter> converter = [[SpringTypeConverterRegistry shared] typeConverterFor:typeDescriptor];
        LogDebug(@"here's the converter: %@", converter);
        STFail(@"Should've thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"No type converter registered for type: 'NSURL'."));
    }


}

@end