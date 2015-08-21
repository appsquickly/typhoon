////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>

#import "TyphoonAssemblyBuilder.h"
#import "MiddleAgesAssembly.h"
#import "ExtendedMiddleAgesAssembly.h"

@interface TyphoonAssemblyBuilderTests : XCTestCase

@end

@implementation TyphoonAssemblyBuilderTests

- (void)test_builder_creates_assembly_from_class
{
    Class assemblyClass = [MiddleAgesAssembly class];
    id result = [TyphoonAssemblyBuilder buildAssemblyWithClass:assemblyClass];
    
    BOOL isRightClass = [result isKindOfClass:[MiddleAgesAssembly class]];
    
    XCTAssertNotNil(result);
    XCTAssertTrue(isRightClass);
}

- (void)test_builder_creates_assemblies_from_classes
{
    NSArray *assemblyClasses = @[[MiddleAgesAssembly class], [ExtendedMiddleAgesAssembly class]];
    NSArray *result = [TyphoonAssemblyBuilder buildAssembliesWithClasses:assemblyClasses];
    
    for (id assembly in result) {
        BOOL isRightClass = [assembly isKindOfClass:[MiddleAgesAssembly class]];
        
        XCTAssertNotNil(assembly);
        XCTAssertTrue(isRightClass);
    }
}

- (void)test_builder_raises_exception_for_wrong_class
{
    Class assemblyClass = [NSObject class];
    
    XCTAssertThrows([TyphoonAssemblyBuilder buildAssemblyWithClass:assemblyClass]);
}

@end
