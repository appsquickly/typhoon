////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <SenTestingKit/SenTestingKit.h>
#import <Typhoon/TyphoonComponentFactory.h>
#import <Typhoon/TyphoonBlockComponentFactory.h>
#import "MiddleAgesAssembly.h"
#import "TyphoonPatcher.h"
#import "Knight.h"
#import "OCLogTemplate.h"
#import "CavalryMan.h"

@interface TyphoonPatcherTests : SenTestCase
{
    MiddleAgesAssembly *_assembly;
    TyphoonComponentFactory *_factory;
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
    [self applyAPatchToFactory:_factory assembly:_assembly];

    [self assertPatchAppliedToFactory:_factory];
}

- (void)test_allows_patching_out_a_loaded_component_with_a_mock
{
    [_factory componentForKey:@"knight"];

    [self applyAPatchToFactory:_factory assembly:_assembly];
    [self assertPatchAppliedToFactory:_factory];
}


- (void)test_honours_the_scope_of_patched_definition
{
    [self applyAPatchToFactory:_factory assembly:_assembly];
    [self assertPatchAppliedToFactory:_factory];

    assertThatBool([_factory componentForKey:@"knight"] == [_factory componentForKey:@"knight"], equalToBool(NO));
    assertThatBool([_factory componentForKey:@"cavalryMan"] == [_factory componentForKey:@"cavalryMan"], equalToBool(YES));


}

- (void)applyAPatchToFactory:(TyphoonComponentFactory *)factory assembly:(MiddleAgesAssembly *)assembly
{
    TyphoonPatcher *patcher = [[TyphoonPatcher alloc] init];
    [patcher patchDefinition:[assembly knight] withObject:^id {
        Knight *mockKnight = mock([Knight class]);
        [given([mockKnight favoriteDamsels]) willReturn:@[
            @"Mary",
            @"Janezzz"
        ]];

        return mockKnight;
    }];

    [patcher patchDefinition:[assembly cavalryMan] withObject:^id {
        CavalryMan *cavalryMan = mock([CavalryMan class]);
        [given ([cavalryMan favoriteDamsels]) willReturn:@[
            @"Leonid",
            @"Bob",
            @"Chuck",
            @"BigDave",
        ]];

        return cavalryMan;
    }];

    [factory attachPostProcessor:patcher];
}

- (void)assertPatchAppliedToFactory:(TyphoonComponentFactory *)factory
{
    Knight *knight = [factory componentForKey:@"knight"];
    assertThatBool([knight favoriteDamsels].count > 0, is(equalToBool(YES)));
}

@end
