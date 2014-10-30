//
//  TyphoonRuntimeInjectionsTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 10.03.14.
//
//

#import <XCTest/XCTest.h>
#import "Typhoon.h"
#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "Mock.h"

@interface TyphoonRuntimeInjectionsTests : XCTestCase

@end

@implementation TyphoonRuntimeInjectionsTests
{
    MiddleAgesAssembly *factory;
}

- (void)setUp
{
    [super setUp];

    factory = [[TyphoonBlockComponentFactory factoryWithAssembly:[MiddleAgesAssembly assembly]] asAssembly];
}

- (void)test_runtime_arguments
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:@6 runtimeFoobar:@"foobar"];
    XCTAssertEqual(knight.damselsRescued, 6);
    XCTAssertEqual(knight.foobar, @"foobar");
}


- (void)test_runtime_block_arguments
{
    __block NSString *foobar = @"initial string";
    Knight *knight = [factory knightWithRuntimeDamselsRescued:@6 runtimeFoobar:(NSObject *) ^(NSString *blockArg){
        foobar = [NSString stringWithFormat:@"set from block %@",blockArg];
    }];
    XCTAssertEqual(knight.damselsRescued, 6);
    ((void(^)(NSString *))knight.foobar)(@"arg");
    XCTAssertEqualObjects(foobar, @"set from block arg");
}

- (void)test_runtime_block_and_class
{

    Mock *mock = [factory mockWithRuntimeBlock:^NSString *{
       return @"Hello";
    } andRuntimeClass:[NSString class]];

    XCTAssertEqualObjects(((NSString *(^)())mock.block)(), @"Hello");
    XCTAssertEqual(mock.clazz, [NSString class]);

}


- (void)test_runtime_knight_quest
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:@3 runtimeQuestUrl:[NSURL URLWithString:@"http://google.com"]];
    XCTAssertEqualObjects([knight.quest imageUrl], [NSURL URLWithString:@"http://google.com"]);
    XCTAssertEqual(knight.damselsRescued, 3);

    knight = [factory knightWithRuntimeDamselsRescued:@2 runtimeQuestUrl:[NSURL URLWithString:@"http://apple.com"]];
    XCTAssertEqualObjects([knight.quest imageUrl], [NSURL URLWithString:@"http://apple.com"]);
    XCTAssertEqual(knight.damselsRescued, 2);
}

- (void)test_runtime_knight_with_nil
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:nil runtimeQuestUrl:[NSURL URLWithString:@"http://google.com"]];
    XCTAssertEqualObjects([knight.quest imageUrl], [NSURL URLWithString:@"http://google.com"]);
    XCTAssertEqual(knight.damselsRescued, 0);
}

- (void)test_runtime_knight_with_method_arg_nil
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:@(12) runtimeQuestUrl:nil];
    XCTAssertNil([knight.quest imageUrl]);
    XCTAssertEqual(knight.damselsRescued, 12);

    Knight *friend = (Knight *) knight.foobar;
    XCTAssertEqual(friend.damselsRescued, 12);
}

- (void)test_runtime_knight_with_method_arg_and_two_nils
{
    Knight *knight = [factory knightWithRuntimeDamselsRescued:nil runtimeQuestUrl:nil];
    XCTAssertNil([knight.quest imageUrl]);
    XCTAssertEqual(knight.damselsRescued, 0);
}

- (void)test_predefined_quest
{
    Knight *knight = [factory knightWithDefinedQuestUrl];
    XCTAssertEqualObjects([knight.quest imageUrl], [NSURL URLWithString:@"http://example.com"]);
}

- (void)test_circular_dependency_with_runtime_args
{
    Knight *knight = [factory knightWithCircularDependencyAndDamselsRescued:@32];
    
    Knight *anotherKnight = (Knight *) knight.foobar;
    
    XCTAssertEqual((int)knight.damselsRescued, 32, @"");
    XCTAssertTrue(anotherKnight.foobar == knight, @"");
    XCTAssertTrue(knight.foobar == anotherKnight, @"");
}

- (void)test_circular_dependency_with_runtime_args_as_nil
{
    Knight *knight = [factory knightWithCircularDependencyAndDamselsRescued:nil];

    Knight *anotherKnight = (Knight *) knight.foobar;

    XCTAssertEqual((int)knight.damselsRescued, (int)nil, @"");
    XCTAssertTrue(anotherKnight.foobar == knight, @"");
    XCTAssertTrue(knight.foobar == anotherKnight, @"");
}

- (void)test_circular_dependency_with_predefined_runtime_args
{
    Knight *knight = [factory knightWithPredefinedCircularDependency:@25];
    
    Knight *anotherKnight = (Knight *) knight.foobar;
    
    XCTAssertEqual((int)knight.damselsRescued, 25, @"");
    XCTAssertEqual(anotherKnight.foobar, knight);
    XCTAssertEqual(knight.foobar, anotherKnight);
}

- (void)test_dependency_with_predefined_runtime_args
{
    Knight *knight = [factory knightWithPredefinedCircularDependency:@27];
    
    Knight *anotherKnight = (Knight *) knight.foobar;
    
    Knight *thirdKnight = (Knight *) anotherKnight.foobar;
    
    XCTAssertEqual((int)knight.damselsRescued, 27, @"");
    XCTAssertEqual((int)thirdKnight.damselsRescued, 25, @"");

    XCTAssertTrue(thirdKnight != knight, @"");
    XCTAssertTrue(knight.foobar == anotherKnight, @"");
}

- (void)test_runtime_argument_with_reference_injection
{
    Knight *knight = [factory knightRuntimeArgumentsFromDefinition];
    XCTAssertEqualObjects(knight.foobar, [[NSURL alloc] initWithString:@"http://google.com"]);
}

- (void)test_runtime_argument_with_reference_injection_with_another_argument
{
    Knight *knight = [factory knightRuntimeArgumentsFromDefinitionWithRuntimeArg];
    XCTAssertEqualObjects(knight.foobar, [[NSURL alloc] initWithString:@"http://typhoonframework.org"]);
}

- (void)test_runtime_argument_with_reference_injection_with_another_runtime_argument
{
    Knight *knight = [factory knightRuntimeArgumentsFromDefinitionsSetWithRuntimeArg];
    XCTAssertEqualObjects(knight.foobar, [[NSURL alloc] initWithString:@"http://example.com"]);
}

@end
