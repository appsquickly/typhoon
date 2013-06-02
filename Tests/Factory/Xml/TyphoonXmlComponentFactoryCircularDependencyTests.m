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
#import "TyphoonComponentFactory.h"
#import "TyphoonXmlComponentFactory.h"
#import "ClassADependsOnB.h"
#import "ClassBDependsOnA.h"


@interface TyphoonXmlComponentFactoryCircularDependencyTests : SenTestCase
@end


@implementation TyphoonXmlComponentFactoryCircularDependencyTests
{
    TyphoonComponentFactory* _circularDependenciesFactory;
}


- (void)setUp
{
    _circularDependenciesFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"CircularDependenciesAssembly.xml"];
}

/* ====================================================================================================================================== */
#pragma mark - Circular dependencies.

- (void)test_resolves_circular_dependencies_for_property_injected_by_reference
{
    ClassADependsOnB* classA = [_circularDependenciesFactory componentForKey:@"classA"];
    NSLog(@"Dependency on B: %@", classA.dependencyOnB);
    assertThat(classA.dependencyOnB, notNilValue());

    ClassBDependsOnA* classB = [_circularDependenciesFactory componentForKey:@"classB"];
    NSLog(@"Dependency on A: %@", classB.dependencyOnA);
    assertThat(classB.dependencyOnA, notNilValue());

}

- (void)test_resolves_circular_dependencies_for_property_injected_by_type
{
    ClassADependsOnB* classA = [_circularDependenciesFactory componentForType:[ClassADependsOnB class]];
    NSLog(@"Dependency on B: %@", classA.dependencyOnB);
    assertThat(classA.dependencyOnB, notNilValue());

    ClassBDependsOnA* classB = [_circularDependenciesFactory componentForType:[ClassBDependsOnA class]];
    NSLog(@"Dependency on A: %@", classB.dependencyOnA);
    assertThat(classB.dependencyOnA, notNilValue());

}


@end
