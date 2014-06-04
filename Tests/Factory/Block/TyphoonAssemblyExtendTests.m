//
//  TyphoonAssemblyExtendTests.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 04.06.14.
//  Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

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
    NemoCoreSecondAssembly *assembly = [_factory asAssembly];
    XCTAssertTrue([[assembly firstViewController] isKindOfClass:[NemoCoreSecondViewController class]]);
}

@end
