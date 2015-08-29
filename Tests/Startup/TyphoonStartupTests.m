//
//  TyphoonStartupTests.m
//  Typhoon
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TyphoonStartup_Testable.h"
#import "TyphoonAppDelegateWithInitialFactoryMock.h"
#import "TyphoonAppDelegateWithInitialAssembliesMock.h"
#import "TyphoonAppDelegateWithBothMethodsMock.h"
#import "MiddleAgesAssembly.h"

@interface TyphoonStartupTests : XCTestCase

@end

@implementation TyphoonStartupTests

- (void)test_factory_from_initial_factory_method
{
    TyphoonAppDelegateWithInitialFactoryMock *appDelegate = [TyphoonAppDelegateWithInitialFactoryMock new];
    
    id factory = [TyphoonStartup factoryFromAppDelegate:appDelegate];
    
    XCTAssertNotNil(factory);
}

- (void)test_factory_from_initial_assemblies_method
{
    TyphoonAppDelegateWithInitialAssembliesMock *appDelegate = [TyphoonAppDelegateWithInitialAssembliesMock new];
    
    id factory = [TyphoonStartup factoryFromAppDelegate:appDelegate];
    
    XCTAssertNotNil(factory);
}

- (void)test_nitial_assemblies_method_is_preferred
{
    TyphoonAppDelegateWithBothMethodsMock *appDelegate = [TyphoonAppDelegateWithBothMethodsMock new];
    
    id factory = [TyphoonStartup factoryFromAppDelegate:appDelegate];
    id knight = [factory knight];
    
    XCTAssertNotNil(factory);
    XCTAssertNotNil(knight);
}

@end
