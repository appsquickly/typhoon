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

@implementation RuntimePropertiesInjectionsTests
{
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

    knight = [factory knightWithRuntimeDamselsRescued:@2 runtimeQuestUrl:[NSURL URLWithString:@"http://apple.com"]];
    assertThat([knight.quest imageUrl], equalTo([NSURL URLWithString:@"http://apple.com"]));
    assertThatInt(knight.damselsRescued, equalToInt(2));
}

- (void)test_runtime_knight_with_nil
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:nil runtimeQuestUrl:[NSURL URLWithString:@"http://google.com"]];
    assertThat([knight.quest imageUrl], equalTo([NSURL URLWithString:@"http://google.com"]));
    assertThatInt(knight.damselsRescued, equalToInt(0));
}


- (void)test_predefined_quest
{
    Knight *knight = [factory knightWithDefinedQuestUrl];
    assertThat([knight.quest imageUrl], equalTo([NSURL URLWithString:@"http://example.com"]));
}

- (void)test_circular_dependency_with_runtime_args
{
    Knight *knight = [factory knightWithDamselsRescued:@32];
    
    Knight *anotherKnight = knight.foobar;
    
    STAssertEquals((int)knight.damselsRescued, 32, @"");
    STAssertTrue(anotherKnight.foobar == knight, @"");
    STAssertTrue(knight.foobar == anotherKnight, @"");
}

- (void)test_circular_dependency_with_predefined_runtime_args
{
    Knight *knight = [factory knightWithPredefinedCircularDependency:@25];
    
    Knight *anotherKnight = knight.foobar;
    
    STAssertEquals((int)knight.damselsRescued, 25, @"");
    STAssertTrue(anotherKnight.foobar == knight, @"");
    STAssertTrue(knight.foobar == anotherKnight, @"");
}

- (void)test_dependency_with_predefined_runtime_args
{
    Knight *knight = [factory knightWithPredefinedCircularDependency:@27];
    
    Knight *anotherKnight = knight.foobar;
    
    Knight *thirdKnight = anotherKnight.foobar;
    
    STAssertEquals((int)knight.damselsRescued, 27, @"");
    STAssertEquals((int)thirdKnight.damselsRescued, 25, @"");

    STAssertTrue(thirdKnight != knight, @"");
    STAssertTrue(knight.foobar == anotherKnight, @"");
}


@end
