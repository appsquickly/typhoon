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

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonAssistedFactoryBase.h"

@interface TyphoonAssistedFactoryBaseTest : SenTestCase
@end

@implementation TyphoonAssistedFactoryBaseTest
{
    TyphoonAssistedFactoryBase *assistedFactory;
}

- (void)setUp
{
    assistedFactory = [[TyphoonAssistedFactoryBase alloc] init];
}

- (void)test_injection_value_should_return_nil_for_unexisting_keys
{
    assertThat([assistedFactory injectionValueForProperty:@"does-not-exist"], is(nilValue()));
}

- (void)test_injection_value_should_return_injected_value
{
    id value = [[NSObject alloc] init];
    [assistedFactory setInjectionValue:value forProperty:@"property"];

    assertThat([assistedFactory injectionValueForProperty:@"property"], is(equalTo(value)));
}

- (void)test_should_respond_to_dummyGetter
{
    assertThatBool([assistedFactory respondsToSelector:@selector(_dummyGetter)], is(equalToBool(YES)));
}

- (void)test_should_respond_to_setDummySetter
{
    assertThatBool([assistedFactory respondsToSelector:@selector(_setDummySetter:)], is(equalToBool(YES)));
}

@end
