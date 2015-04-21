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
#import "Typhoon.h"
#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "Mock.h"
#import "TyphoonAssemblyActivator.h"
#import "Sword.h"

@interface TyphoonRuntimeInjectionsTests : XCTestCase

@end

@implementation TyphoonRuntimeInjectionsTests
{
    MiddleAgesAssembly *factory;
}

- (void)setUp
{
    [super setUp];

    factory = [[MiddleAgesAssembly assembly] activate];
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

- (void)test_runtime_argument_shortcut
{
    NSString *str = [factory stringValueShortcut];
    XCTAssertEqualObjects(str, @"Hello world!");
}

- (void)test_runtime_argument_shortcut_more_than_one_arg
{
    Knight *knight = [factory knightWithRuntimeQuestUrl:[NSURL URLWithString:@"http://appsquick.ly"]];
    XCTAssertEqualObjects(knight.quest.imageUrl, [NSURL URLWithString:@"http://appsquick.ly"]);
    XCTAssertTrue(knight.damselsRescued == 13);
}

- (void)test_runtime_argument_shortcut_block_and_class
{
    Mock *mock1 = [factory mockWithRuntimeClass:[NSString class]];

    XCTAssertTrue(mock1.clazz == [NSString class]);
    XCTAssertTrue([((NSString*(^)()) mock1.block)() isEqualToString:@"Hello"]);

    Mock *mock2 = [factory mockWithRuntimeBlock:^NSString * {
        return @"Hello2";
    }];

    XCTAssertTrue(mock2.clazz == [NSString class]);
    XCTAssertTrue([((NSString*(^)()) mock2.block)() isEqualToString:@"Hello2"]);
}

- (void)test_runtime_argument_shortcut_point_to_shortcut
{
    Knight *knight = [factory knightWithPredefinedRuntimeQuest];
    XCTAssertEqualObjects(knight.quest.imageUrl, [NSURL URLWithString:@"http://appsquick.ly"]);
    XCTAssertTrue(knight.damselsRescued == 13);
}

- (void)test_runtime_argument_with_error_writeback
{
    __autoreleasing NSError *error = nil;
    Sword *sword = [factory swordWithSpec:@"blue" error:[NSValue valueWithPointer:&error]];
    XCTAssertEqualObjects(sword.specification, @"blue sword");
    XCTAssertNil(error);

    __autoreleasing NSError *error2 = nil;
    Sword *yellow = [factory swordWithSpec:@"yellow" error:[NSValue valueWithPointer:&error2]];
    XCTAssertNotNil(yellow);
    XCTAssertNotNil(error2);
    XCTAssertEqual(error2.code, (NSInteger)404);
}

@end
