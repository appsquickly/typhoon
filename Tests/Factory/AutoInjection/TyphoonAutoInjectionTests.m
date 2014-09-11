//
//  TyphoonAutoInjectionTests.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 12.09.14.
//  Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

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
