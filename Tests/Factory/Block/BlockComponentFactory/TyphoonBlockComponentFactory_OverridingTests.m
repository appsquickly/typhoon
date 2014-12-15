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


#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "TyphoonComponentFactory.h"
#import "TyphoonBlockComponentFactory.h"
#import "OCLogTemplate.h"
#import "ExtendedMiddleAgesAssembly.h"
#import "Knight.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "CampaignQuest.h"


@interface TyphoonBlockComponentFactory_OverridingTests : XCTestCase
@end


@implementation TyphoonBlockComponentFactory_OverridingTests
{

}

- (void)test_allows_overriding_methods_in_an_assembly
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
        [ExtendedMiddleAgesAssembly assembly],
    ]];

    Knight *knight = [(ExtendedMiddleAgesAssembly *) factory yetAnotherKnight];
    LogTrace(@"Knight: %@", knight);
    XCTAssertNotNil(knight);
}

- (void)test_allows_overriding_methods_in_a_collaborating_assembly
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
        [ExtendedMiddleAgesAssembly assembly],
        [CollaboratingMiddleAgesAssembly assembly],
    ]];

    Knight *knight = [(CollaboratingMiddleAgesAssembly *) factory knightWithExternalQuest];
    XCTAssertNotNil(knight);
    XCTAssertTrue([knight.quest isKindOfClass:[CampaignQuest class]]);
    XCTAssertEqualObjects(knight.quest.imageUrl, [NSURL URLWithString:@"www.foobar.com/quest"]);
}


@end