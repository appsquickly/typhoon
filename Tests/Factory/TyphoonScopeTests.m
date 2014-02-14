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
#import "ObjectGraphAssembly.h"
#import "TyphoonBlockComponentFactory.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "Fort.h"

@interface TyphoonScopeTests : SenTestCase {
    ObjectGraphAssembly *_assembly;
}

@end

@implementation TyphoonScopeTests

- (void)setUp {
    TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ObjectGraphAssembly assembly]];
    _assembly = (ObjectGraphAssembly *) factory;
}


- (void)test_object_graph_scope {
    Knight *objectGraphKnight = [_assembly objectGraphKnight];
    CampaignQuest *quest = objectGraphKnight.quest;
    assertThatBool(objectGraphKnight.homeFort == quest.fort, equalToBool(YES));

    Knight *prototypeKnight = [_assembly prototypeKnight];
    CampaignQuest *prototypeQuest = prototypeKnight.quest;
    assertThatBool(prototypeKnight.homeFort == prototypeQuest.fort, equalToBool(NO));
}

@end
