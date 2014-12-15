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
#import "ComponentFactoryAwareObject.h"
#import "TyphoonBlockComponentFactory.h"
#import "ComponentFactoryAwareAssembly.h"

@interface TyphoonComponentFactoryAwareTests : XCTestCase

@end


@implementation TyphoonComponentFactoryAwareTests
{
    ComponentFactoryAwareObject *object;
    ComponentFactoryAwareAssembly *factory;
}

- (void)setUp;
{
    factory = (id) [[TyphoonBlockComponentFactory alloc] initWithAssembly:[ComponentFactoryAwareAssembly assembly]];
}

- (void)test_reference_to_assembly_set_on_injection_aware_object;
{
    object = [factory injectionAwareObject];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_property
{
    object = [factory injectionByProperty];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_initialization
{
    object = [factory injectionByProperty];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_property_assembly_type
{
    object = [factory injectionByPropertyAssemblyType];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_property_factory_type
{
    object = [factory injectionByPropertyFactoryType];
    XCTAssertTrue(object.factory == factory);
}


@end
