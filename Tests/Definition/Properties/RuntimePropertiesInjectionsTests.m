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
#import "Quest.h"

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

- (void)test_runtime_knight_quest
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:@3 runtimeQuestUrl:[NSURL URLWithString:@"http://google.com"]];
    assertThat([knight.quest imageUrl], equalTo([NSURL URLWithString:@"http://google.com"]));
    assertThatInt(knight.damselsRescued, equalToInt(3));
}

- (void)test_predefined_quest
{
    Knight *knight = [factory knightWithDefinedQuestUrl];
    assertThat([knight.quest imageUrl], equalTo([NSURL URLWithString:@"http://example.com"]));
}


@end
