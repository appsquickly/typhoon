////////////////////////////////////////////////////////////////////////////////
//
//  MOD PRODUCTIONS
//  Copyright 2013 Mod Productions
//  All Rights Reserved.
//
//  NOTICE: Mod Productions permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "CircularDependenciesAssembly.h"


@interface TyphoonBlockComponentFactoryCircularDependencyTests : SenTestCase
@end

@implementation TyphoonBlockComponentFactoryCircularDependencyTests
{
    TyphoonComponentFactory* _circularDependenciesFactory;
}



/* ====================================================================================================================================== */
#pragma mark - Circular dependencies.

- (void)test_prevents_circular_dependencies_by_reference
{
    @try
    {
        _circularDependenciesFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[CircularDependenciesAssembly assembly]];

        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Circular dependency detected."));
    }
}


@end