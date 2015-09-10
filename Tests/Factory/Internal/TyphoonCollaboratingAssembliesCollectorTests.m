////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>

#import "TyphoonCollaboratingAssembliesCollector.h"
#import "TyphoonLoopedCollaboratingAssemblies.h"
#import "TyphoonSingleAssembly.h"

@interface TyphoonCollaboratingAssembliesCollectorTests : XCTestCase

@end

@implementation TyphoonCollaboratingAssembliesCollectorTests

- (void)test_collector_returns_proper_collaborators
{
    Class initialAssemblyClass = [TyphoonFirstLoopAssembly class];
    TyphoonCollaboratingAssembliesCollector *collector = [[TyphoonCollaboratingAssembliesCollector alloc] initWithAssemblyClass:initialAssemblyClass];
    
    NSSet *expectedCollaboratorClasses = [NSSet setWithObjects:[TyphoonSecondLoopAssembly class], [TyphoonThirdLoopAssembly class], nil];
    
    NSSet *collaborators = [collector collectCollaboratingAssemblies];
    
    XCTAssertEqual(collaborators.count, expectedCollaboratorClasses.count);
    for (TyphoonAssembly *assembly in collaborators) {
        Class assemblyClass = [assembly class];
        XCTAssertTrue([expectedCollaboratorClasses containsObject:assemblyClass]);
    }
}

- (void)test_collector_works_properly_with_single_assembly
{
    Class initialAssemblyClass = [TyphoonSingleAssembly class];
    TyphoonCollaboratingAssembliesCollector *collector = [[TyphoonCollaboratingAssembliesCollector alloc] initWithAssemblyClass:initialAssemblyClass];
    
    NSUInteger expectedCollaboratorsCount = 0;
    
    NSSet *collaborators = [collector collectCollaboratingAssemblies];
    
    XCTAssertEqual(collaborators.count, expectedCollaboratorsCount);
}

@end
