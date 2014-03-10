//
//  RuntimePropertiesInjectionsTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 10.03.14.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "Typhoon.h"
#import "MiddleAgesAssembly.h"
#import "Knight.h"

@interface RuntimePropertiesInjectionsTests : SenTestCase

@end

@implementation RuntimePropertiesInjectionsTests {
    MiddleAgesAssembly *factory;
}

- (void)setUp
{
    [super setUp];
    
    factory = [TyphoonBlockComponentFactory factoryWithAssembly:[MiddleAgesAssembly assembly]];
}

- (void)test_runtime_arguments
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:@6 runtimeFoobar:@"foobar"];
    assertThatInt(knight.damselsRescued, equalToInt(6));
    assertThat(knight.foobar, equalTo(@"foobar"));
}

@end
