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

@interface TyphoonPatcherTests : SenTestCase
{
    MiddleAgesAssembly* _assembly;
}

@end


@implementation TyphoonPatcherTests

- (void)test_allows_patching_out_a_component_with_a_mock
{
    TyphoonComponentFactory* factory = [TyphoonBlockComponentFactory factoryWithAssembly:[MiddleAgesAssembly assembly]];

    TyphoonPatcher* patcher = [[TyphoonPatcher alloc] init];
    [patcher patchDefinitionWithKey:@"knight" withObject:^id
    {
        Knight* mockKnight = mock([Knight class]);
        [given([mockKnight favoriteDamsels]) willReturn:@[
            @"Mary",
            @"Janezzz"
        ]];

        return mockKnight;
    }];

    [factory attachMutator:patcher];

    Knight* knight = [factory componentForKey:@"knight"];
    LogDebug(@"Damsels: %@", [knight favoriteDamsels]);

}

@end
