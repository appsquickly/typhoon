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
}

- (void)setUp
{


    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testExtented
{
    TyphoonBlockComponentFactory *_factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[
            [NemoCoreSecondAssembly assembly]
    ]];
    NemoCoreSecondAssembly *assembly = (NemoCoreSecondAssembly*)_factory;
    XCTAssertTrue([[assembly firstViewController] isKindOfClass:[NemoCoreSecondViewController class]]);
}

- (void)testMultipleOverrides
{
    NemoCoreNemoAssembly *assembly = [NemoCoreNemoAssembly new];
    assembly = [assembly activate];
    XCTAssertTrue([assembly.firstViewController isKindOfClass:[NemoCoreFirstViewController class]]);

    NemoCoreSecondAssembly *assembly2 = [NemoCoreSecondAssembly new];
    assembly2 = [assembly2 activate];
    XCTAssertTrue([assembly2.firstViewController isKindOfClass:[NemoCoreSecondViewController class]]);


    NemoCoreNemoAssembly *assembly3 = [NemoCoreNemoAssembly new];
    assembly3 = [assembly3 activate];

    XCTAssertTrue([assembly3.firstViewController isKindOfClass:[NemoCoreFirstViewController class]]);

    NemoCoreSecondAssembly *assembly4 = [NemoCoreSecondAssembly new];
    assembly4 = [assembly4 activate];
    XCTAssertTrue([assembly4.firstViewController isKindOfClass:[NemoCoreSecondViewController class]]);


}

@end
