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

- (void)test_prevents_circular_dependencies_by_reference
{
    @try
    {
        ClassADependsOnB* classA = [_circularDependenciesFactory componentForKey:@"classA"];
        NSLog(@"Class A: %@", classA); //Suppress unused var compiler warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        NSLog(@"Exception: %@", e);
        assertThat([e description], equalTo(@"Circular dependency detected: {(\n    classB,\n    classA\n)}"));
    }
}

- (void)test_prevents_circular_dependencies_by_type
{
    TyphoonXmlComponentFactory* factory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"CircularDependenciesAssembly.xml"];

    @try
    {
        ClassADependsOnB* classA = [factory componentForType:[ClassADependsOnB class]];
        NSLog(@"Class A: %@", classA); //Suppress unused var compiler warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        NSLog(@"%@", [e description]);
        assertThat([e description], equalTo(@"Circular dependency detected: {(\n    classB,\n    classA\n)}"));
    }
}


@end
