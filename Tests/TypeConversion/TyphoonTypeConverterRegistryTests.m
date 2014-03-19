////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeDescriptor.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonNSURLTypeConverter.h"


@interface TyphoonTypeConverterRegistryTests : SenTestCase

@property(nonatomic, strong) NSData *data;

@end

@implementation TyphoonTypeConverterRegistryTests
{
    TyphoonTypeConverterRegistry *_registry;
}

- (void)setUp
{
    _registry = [TyphoonTypeConverterRegistry shared];
}

- (void)test_raises_exception_when_converter_class_not_registered
{
    id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterForType:@"NSData"];
    assertThat(converter, nilValue());
}

- (void)test_raises_exception_when_converter_registered_more_than_once
{
    @try {
        TyphoonNSURLTypeConverter *converter = [[TyphoonNSURLTypeConverter alloc] init];
        [_registry registerTypeConverter:converter];
        STFail(@"SHould have thrown exception");
    }
    @catch (NSException *e) {
        assertThat([e description], equalTo(@"Converter for 'NSURL' already registered."));
    }

}

@end