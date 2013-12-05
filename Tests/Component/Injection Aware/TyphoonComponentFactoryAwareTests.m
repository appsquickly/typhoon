//
//  TyphoonComponentFactoryAwareTests.m
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//
//

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
