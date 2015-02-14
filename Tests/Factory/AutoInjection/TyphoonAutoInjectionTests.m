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
#import "TyphoonComponentFactory.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAutoInjectionAssembly.h"
#import "AutoInjectionKnight.h"

@interface TyphoonAutoInjectionTests : XCTestCase

@end

@implementation TyphoonAutoInjectionTests {
    TyphoonComponentFactory *factoryWithKnight;
    TyphoonComponentFactory *factoryWithoutKnight;
}

- (void)setUp
{
    [super setUp];

    factoryWithKnight = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[TyphoonAutoInjectionAssembly assembly],
        [TyphoonAutoInjectionAssemblyWithKnight assembly]]];

    factoryWithoutKnight = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[TyphoonAutoInjectionAssembly assembly]]];
}

- (void)testAutoInjectionWithAssembly
{
    TyphoonAutoInjectionAssemblyWithKnight *assemblyInterface = (id)factoryWithKnight;

    AutoInjectionKnight *knight = [assemblyInterface autoInjectedKnight];

    XCTAssertNotNil(knight.autoQuest);
    XCTAssertNotNil(knight.autoFort);
}

- (void)testAutoInjectionWithoutAssembly
{
    AutoInjectionKnight *knight = [factoryWithoutKnight componentForType:[AutoInjectionKnight class]];

    XCTAssertNotNil(knight.autoQuest);
    XCTAssertNotNil(knight.autoFort);
}


@end
