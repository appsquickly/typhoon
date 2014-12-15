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
#import "MiddleAgesAssembly.h"
#import "TyphoonPatcher.h"
#import "Knight.h"
#import "OCLogTemplate.h"
#import "CavalryMan.h"

@interface TyphoonPatcherTests : XCTestCase
{
    MiddleAgesAssembly *_assembly;
    TyphoonComponentFactory *_factory;
    TyphoonPatcher *_patcher;
}

@end


@implementation TyphoonPatcherTests

- (void)setUp
{
    [super setUp];

    _assembly = [MiddleAgesAssembly assembly];
    _factory = [TyphoonBlockComponentFactory factoryWithAssembly:_assembly];
}

- (void)test_allows_patching_out_a_component_with_a_mock
{
    [self applyAPatch];
    [self assertPatchApplied];
}

- (void)test_allows_patching_out_a_loaded_component_with_a_mock
{
    [_factory componentForKey:@"knight"];

    [self applyAPatch];
    [self assertPatchApplied];
}


- (void)test_honours_the_scope_of_patched_definition
{
    [self applyAPatch];
    [self assertPatchApplied];

    XCTAssertFalse([_factory componentForKey:@"knight"] == [_factory componentForKey:@"knight"]);
    XCTAssertTrue([_factory componentForKey:@"cavalryMan"] == [_factory componentForKey:@"cavalryMan"]);
}

- (void)test_patcher_with_runtime_args
{
    MiddleAgesAssembly *factory = (MiddleAgesAssembly *)_factory;

    [self applyAPatch];
    [self assertPatchApplied];

    Knight *knight = [factory knightWithFoobar:@"123"];
    XCTAssertEqual(knight.foobar, @"Fooooo");

    [_patcher detach];

    knight = [factory knightWithFoobar:@"123"];
    XCTAssertEqual(knight.foobar, @"123");

}

- (void)test_allows_detaching_patcher
{
    [self applyAPatch];
    [self assertPatchApplied];

    XCTAssertFalse([_factory componentForKey:@"knight"] == [_factory componentForKey:@"knight"]);
    XCTAssertTrue([_factory componentForKey:@"cavalryMan"] == [_factory componentForKey:@"cavalryMan"]);

    [_patcher detach];

    Knight *knight = [_factory componentForKey:@"knight"];
    LogDebug(@"%@", [knight favoriteDamsels]);
}

- (void)applyAPatch
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly assembly];
    _patcher = [[TyphoonPatcher alloc] init];
    [_patcher patchDefinition:[assembly knight] withObject:^id {
        Knight *mockKnight = mock([Knight class]);
        [given([mockKnight favoriteDamsels]) willReturn:@[
            @"Mary",
            @"Janezzz"
        ]];

        return mockKnight;
    }];

    [_patcher patchDefinitionWithSelector:@selector(cavalryMan) withObject:^id {
        CavalryMan *cavalryMan = mock([CavalryMan class]);
        [given ([cavalryMan favoriteDamsels]) willReturn:@[
            @"Leonid",
            @"Bob",
            @"Chuck",
            @"BigDave",
        ]];

        return cavalryMan;
    }];

    [_patcher patchDefinitionWithSelector:@selector(knightWithFoobar:) withObject:^id {
        Knight *knight = [Knight new];
        knight.foobar = @"Fooooo";
        return knight;
    }];

    [_factory attachPostProcessor:_patcher];
}

- (void)assertPatchApplied
{
    Knight *knight = [_factory componentForKey:@"knight"];
    XCTAssertTrue([knight favoriteDamsels].count > 0);
}


@end
