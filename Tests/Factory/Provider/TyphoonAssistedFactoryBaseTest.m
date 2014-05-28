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

#import <XCTest/XCTest.h>
#import "TyphoonAssistedFactoryBase.h"

#import "TyphoonComponentFactory.h"
#import "TyphoonAbstractInjection.h"

@interface TyphoonAssistedFactoryBaseTest : XCTestCase
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
    XCTAssertNil([assistedFactory injectionValueForProperty:@"does-not-exist"]);
}

- (void)test_injection_value_should_return_injected_value
{
    TyphoonPropertyInjectionLazyValue value = ^id {
        return nil;
    };

    id mockProperty = mock([TyphoonAbstractInjection class]);
    [given([mockProperty propertyName]) willReturn:@"property"];
    [assistedFactory shouldInjectProperty:mockProperty withType:nil lazyValue:value];

    XCTAssertEqualObjects([assistedFactory injectionValueForProperty:@"property"], value);
}

- (void)test_dependency_value_should_return_value_returned_from_injected_value
{
    id value = [[NSObject alloc] init];
    TyphoonPropertyInjectionLazyValue lazyValue = ^id {
        return value;
    };

    id mockProperty = mock([TyphoonAbstractInjection class]);
    [given([mockProperty propertyName]) willReturn:@"property"];
    [assistedFactory shouldInjectProperty:mockProperty withType:nil lazyValue:lazyValue];

    XCTAssertEqual([assistedFactory dependencyValueForProperty:@"property"], value);
}

- (void)test_should_respond_to_dummyGetter
{
    XCTAssertTrue([assistedFactory respondsToSelector:@selector(_dummyGetter)]);
}

- (void)test_should_conform_to_TyphoonComponentFactoryAware
{
    id mockFactory = mock([TyphoonComponentFactory class]);

    [assistedFactory typhoonSetFactory:mockFactory];
    XCTAssertEqualObjects(assistedFactory.componentFactory, mockFactory);
}

@end
