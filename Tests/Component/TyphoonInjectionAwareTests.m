//
//  TyphoonInjectionAwareTests.m
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "InjectionAwareObject.h"
#import <TyphoonBlockComponentFactory.h>
#import "InjectionAwareAssembly.h"

@interface TyphoonInjectionAwareTests : SenTestCase

@end



@implementation TyphoonInjectionAwareTests {
    InjectionAwareObject *object;
    InjectionAwareAssembly *factory;
}

- (void)setUp;
{
    factory = (id)[[TyphoonBlockComponentFactory alloc] initWithAssembly:[InjectionAwareAssembly assembly]];
}

- (void)test_reference_to_assembly_set_on_injection_aware_object;
{
    object = [factory injectionAwareObject];
    assertThat(object.assembly, sameInstance(factory));
}

@end
