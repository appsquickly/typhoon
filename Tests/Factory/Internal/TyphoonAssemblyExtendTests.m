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
#import "TyphoonNemoTestAssemblies.h"
#import "TyphoonBlockComponentFactory.h"

@interface TyphoonAssemblyExtendTests : XCTestCase

@end

@implementation TyphoonAssemblyExtendTests {
    TyphoonBlockComponentFactory *_factory;
}

- (void)setUp
{
    _factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[
        [NemoCoreSecondAssembly assembly]
    ]];

    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testExtented
{
    NemoCoreSecondAssembly *assembly = (NemoCoreSecondAssembly*)_factory;
    XCTAssertTrue([[assembly firstViewController] isKindOfClass:[NemoCoreSecondViewController class]]);
}

@end
