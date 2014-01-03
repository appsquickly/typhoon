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

@interface TyphoonBlockComponentFactory_InvalidCollaboratingAssembliesTests : SenTestCase
@end


@implementation TyphoonBlockComponentFactory_InvalidCollaboratingAssembliesTests
{

}

- (void)testPropertyInjectionDirectlyUsesAnotherAssembly
{
    @try {
        TyphoonBlockComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[InvalidCollaboratingAssembly assembly]];
        STFail(@"Should have thrown an exception when directly using another assembly in a definition.");
    }@catch (NSException *exception) {
        assertThat([exception name], equalTo(TyphoonAssemblyInvalidException));
        assertThat([exception reason], equalTo(@"The definition 'knightWithExternalQuest' on assembly 'InvalidCollaboratingAssembly' attempts to perform property injection with an instance of a different assembly.\nUse a collaborating assembly proxy instead."));
    }
}

- (void)testInitializerInjectionDirectlyUsesAnotherAssembly
{
    @try {
        TyphoonBlockComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[InvalidCollaboratingAssembly_Initializer assembly]];
        STFail(@"Should have thrown an exception when directly using another assembly in a definition.");
    }@catch (NSException *exception) {
        assertThat([exception name], equalTo(TyphoonAssemblyInvalidException));
        assertThat([exception reason], equalTo(@"The definition 'knightWithExternalQuest' on assembly 'InvalidCollaboratingAssembly_Initializer' attempts to perform initializer injection with an instance of a different assembly.\nUse a collaborating assembly proxy instead."));
    }
}

@end