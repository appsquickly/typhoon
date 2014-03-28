//
//  TyphoonMethodInjectionsTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 27.03.14.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "MethodInjectinosAssembly.h"
#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "Quest.h"

@interface TyphoonMethodInjectionsTests : SenTestCase

@end

@implementation TyphoonMethodInjectionsTests {
    MethodInjectinosAssembly *factory;
}

- (void)setUp
{
    factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[MiddleAgesAssembly assembly], [MethodInjectinosAssembly assembly]]];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)test_method_injection
{
    Knight *knight = [factory knightInjectedByMethod];
    STAssertNotNil(knight.quest, nil);
    STAssertEquals((int)knight.damselsRescued, 3, nil);
}

- (void)test_method_circular_injection_with_array
{
    Knight *knight = [factory knightWithCircularDependency];
    
    NSArray *damsels = knight.favoriteDamsels;
    
    Knight *another = damsels[0];
    
    STAssertTrue(knight == another.foobar, @"knight=%@, another=%@",knight, another);
    STAssertTrue(damsels.count == 2, nil);
}

- (void)test_method_three_argument
{
    Knight *knight = [factory knightWithMethodRuntimeFoo:@"foo"];
    STAssertEqualObjects(knight.foobar, @"foo", nil);
}

- (void)test_method_nil_argument
{
    Knight *knight = [factory knightWithMethodFoo:nil];
    
    STAssertTrue([knight.friends count] == 2, nil);
    STAssertTrue(knight.hasHorseWillTravel, nil);
    STAssertTrue(knight.foobar == nil, nil);
}




@end
