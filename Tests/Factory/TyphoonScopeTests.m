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
#import "OCLogTemplate.h"

@interface TyphoonScopeTests : SenTestCase
{
    ObjectGraphAssembly* _assembly;
}

@end

@implementation TyphoonScopeTests

- (void)setUp
{
    TyphoonBlockComponentFactory* factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ObjectGraphAssembly assembly]];
    _assembly = (ObjectGraphAssembly*)factory;
}


//- (void)test_object_graph_assembly
//{
//    Knight* knight = [_assembly objectGraphKnight];
//    CampaignQuest* quest = [_assembly objectGraphQuest];
//
//    LogDebug(@"Knight's fort: %@", knight.homeFort);
//    LogDebug(@"Quest's fort: %@", quest.fort);
//
//    assertThatBool(knight.homeFort == quest.fort, equalToBool(YES));
//}

@end
