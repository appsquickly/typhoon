////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonBlockComponentFactory.h"
#import "InvalidCollaboratingAssembly.h"
#import "InvalidCollaboratingAssembly_Initializer.h"
#import "TyphoonAssemblyValidator.h"

@interface TyphoonBlockComponentFactory_InvalidCollaboratingAssembliesTests : SenTestCase
@end


@implementation TyphoonBlockComponentFactory_InvalidCollaboratingAssembliesTests
{

}

- (void)testPropertyInjectionDirectlyUsesAnotherAssembly
{
    @try
    {
        TyphoonBlockComponentFactory
                * factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[InvalidCollaboratingAssembly assembly]];
        STFail(@"Should have thrown an exception when directly using another assembly in a definition.");
    } @catch (NSException* exception)
    {
        assertThat([exception name], equalTo(TyphoonAssemblyInvalidException));
        assertThat([exception reason], equalTo(@"Unable to find a definition to supply the 'quest' property of the 'knightWithExternalQuest' on the 'InvalidCollaboratingAssembly'.\nDouble check to make sure you're not attempting to perform injection with an instance of a different assembly directly and are instead using a property as a proxy for the collaborating assembly."));
    }
}

- (void)testInitializerInjectionDirectlyUsesAnotherAssembly
{
    @try
    {
        TyphoonBlockComponentFactory
                * factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[InvalidCollaboratingAssembly_Initializer assembly]];
        STFail(@"Should have thrown an exception when directly using another assembly in a definition.");
    } @catch (NSException* exception)
    {
        assertThat([exception name], equalTo(TyphoonAssemblyInvalidException));
        assertThat([exception reason], equalTo(@"Unable to find a definition to supply the 1st initializer parameter of the 'knightWithExternalQuest' on the 'InvalidCollaboratingAssembly_Initializer'.\nDouble check to make sure you're not attempting to perform injection with an instance of a different assembly directly and are instead using a property as a proxy for the collaborating assembly."));
    }
}

@end