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
#import "ComponentFactoryAwareObject.h"
#import <TyphoonBlockComponentFactory.h>
#import "ComponentFactoryAwareAssembly.h"

@interface TyphoonComponentFactoryAwareTests : SenTestCase

@end



@implementation TyphoonComponentFactoryAwareTests
{
    ComponentFactoryAwareObject*object;
    ComponentFactoryAwareAssembly*factory;
}

- (void)setUp;
{
    factory = (id)[[TyphoonBlockComponentFactory alloc] initWithAssembly:[ComponentFactoryAwareAssembly assembly]];
}

- (void)test_reference_to_assembly_set_on_injection_aware_object;
{
    object = [factory injectionAwareObject];
    assertThat(object.factory, sameInstance(factory));
}

@end
