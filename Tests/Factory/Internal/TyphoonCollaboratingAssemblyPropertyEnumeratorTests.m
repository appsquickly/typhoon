////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <XCTest/XCTest.h>
#import "TyphoonCollaboratingAssemblyPropertyEnumerator.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "ExtendedMiddleAgesAssembly.h"
#import "ExtendedSimpleAssembly.h"
#import "TyphoonCollaboratingAssemblyPropertyEnumeratorTests_AssemblyWithProperty.h"

@interface TyphoonCollaboratingAssemblyPropertyEnumeratorTests : XCTestCase
@end


@implementation TyphoonCollaboratingAssemblyPropertyEnumeratorTests
{

}

- (void)test_assembly_property_implements_protocol
{
    TyphoonCollaboratingAssemblyPropertyEnumerator
        *enumerator = [[TyphoonCollaboratingAssemblyPropertyEnumerator alloc] initWithAssembly:[CollaboratingMiddleAgesAssembly assembly]];

    XCTAssertTrue([[enumerator collaboratingAssemblyProperties] count] == 1);
    XCTAssertNotNil([[enumerator collaboratingAssemblyProperties] member:@"quests"]);
}

- (void)test_assembly_properties_include_superclasses
{
    TyphoonCollaboratingAssemblyPropertyEnumerator
        *enumerator = [[TyphoonCollaboratingAssemblyPropertyEnumerator alloc] initWithAssembly:[ExtendedSimpleAssembly assembly]];

    XCTAssertTrue([[enumerator collaboratingAssemblyProperties] count] == 2);
    XCTAssertNotNil([[enumerator collaboratingAssemblyProperties] member:@"assemblyA"]);
    XCTAssertNotNil([[enumerator collaboratingAssemblyProperties] member:@"assemblyB"]);

}

- (void)test_excludes_non_assembly_types
{
    TyphoonCollaboratingAssemblyPropertyEnumerator
        *enumerator = [[TyphoonCollaboratingAssemblyPropertyEnumerator alloc] initWithAssembly:[AssemblyWithProperty assembly]];

    XCTAssertTrue([[enumerator collaboratingAssemblyProperties] count] == 1);
    XCTAssertNotNil([[enumerator collaboratingAssemblyProperties] member:@"assembly"]);
}

@end