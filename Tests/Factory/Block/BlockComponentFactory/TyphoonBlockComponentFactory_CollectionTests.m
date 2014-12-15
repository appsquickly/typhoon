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
#import "MiddleAgesAssembly.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "Knight.h"
#import "CampaignQuest.h"


@interface TyphoonBlockComponentFactory_CollectionTests : XCTestCase
@end


@implementation TyphoonBlockComponentFactory_CollectionTests
{

}

- (void)test_allows_initialization_with_a_collection_of_assemblies
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
        [MiddleAgesAssembly assembly],
        [CollaboratingMiddleAgesAssembly assembly],
    ]];

    Knight *knight = [(CollaboratingMiddleAgesAssembly *) factory knightWithExternalQuest];
    XCTAssertNotNil(knight);
    XCTAssertTrue([knight.quest isKindOfClass:[CampaignQuest class]]);
}

- (void)test_allows_initialization_with_a_collection_of_assemblies_in_any_order
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
        [CollaboratingMiddleAgesAssembly assembly],
        [MiddleAgesAssembly assembly]
    ]];

    Knight *knight = [(CollaboratingMiddleAgesAssembly *) factory knightWithExternalQuest];
    XCTAssertNotNil(knight);
    XCTAssertTrue([knight.quest isKindOfClass:[CampaignQuest class]]);
}


@end
