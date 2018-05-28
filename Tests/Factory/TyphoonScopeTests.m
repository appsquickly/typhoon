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
#import "ObjectGraphAssembly.h"
#import "TyphoonBlockComponentFactory.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "Fort.h"
#import "PrototypeAssembly.h"


@interface TyphoonScopeTests : XCTestCase
{
    ObjectGraphAssembly *_assembly;
}

@end

@implementation TyphoonScopeTests

- (void)setUp
{
    TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ObjectGraphAssembly assembly]];
    _assembly = (ObjectGraphAssembly *) factory;
}


- (void)test_object_graph_scope
{
    Knight *objectGraphKnight = [_assembly objectGraphKnight];
    CampaignQuest *quest = objectGraphKnight.quest;
    XCTAssertTrue(objectGraphKnight.homeFort == quest.fort);

    Knight *prototypeKnight = [_assembly prototypeKnight];
    CampaignQuest *prototypeQuest = prototypeKnight.quest;
    XCTAssertFalse(prototypeKnight.homeFort == prototypeQuest.fort);
}

- (void)test_prototype_scope
{
    PrototypeAssembly *assembly = [[PrototypeAssembly assembly] activated];
    
    Knight *knight = [assembly prototypeKnight];
    XCTAssertNotNil(knight);
    
    Knight *anotherKnight = [assembly prototypeKnight];
    XCTAssertNotNil(anotherKnight);
    XCTAssertFalse(anotherKnight == knight);
}

- (void)test_prototype_with_circular_reference
{
    PrototypeAssembly *assembly = [[PrototypeAssembly assembly] activated];
    
    Knight *knight = [assembly prototypeKnightWithFort];
    XCTAssertNotNil(knight);
    XCTAssertNotNil(knight.homeFort);
    XCTAssertEqual(knight.homeFort.owner, knight);
}

- (void)test_general_knight_for_different_kings
{
    PrototypeAssembly *assembly = [[PrototypeAssembly assembly] activated];

    King *arthur = [assembly kingArthur];
    XCTAssertEqualObjects(arthur.name, @"Arthur");
    XCTAssertEqualObjects(arthur.personalGuard.name, @"Arthur's personal guard");
    
    King *mordred = [assembly kingMordred];
    XCTAssertEqualObjects(mordred.name, @"Mordred");
    XCTAssertNotEqual(mordred.personalGuard, arthur.personalGuard);
    XCTAssertEqualObjects(mordred.personalGuard.name, @"Mordred's personal guard");
}

@end
