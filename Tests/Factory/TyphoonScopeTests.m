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

@end
