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


#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <Typhoon/TyphoonComponentFactory.h>
#import <Typhoon/TyphoonBlockComponentFactory.h>
#import <Typhoon/OCLogTemplate.h>
#import "ExtendedMiddleAgesAssembly.h"
#import "Knight.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "CampaignQuest.h"


@interface TyphoonBlockComponentFactory_OverridingTests : SenTestCase
@end


@implementation TyphoonBlockComponentFactory_OverridingTests
{

}

- (void)test_allows_overriding_methods_in_an_assembly {
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
        [ExtendedMiddleAgesAssembly assembly],
    ]];

    Knight *knight = [(ExtendedMiddleAgesAssembly *) factory yetAnotherKnight];
    LogTrace(@"Knight: %@", knight);
    assertThat(knight, notNilValue());
}

- (void)test_allows_overriding_methods_in_a_collaborating_assembly
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
        [ExtendedMiddleAgesAssembly assembly],
        [CollaboratingMiddleAgesAssembly assembly],
    ]];

    Knight *knight = [(CollaboratingMiddleAgesAssembly *) factory knightWithExternalQuest];
    assertThat(knight, notNilValue());
    assertThatBool([knight.quest isKindOfClass:[CampaignQuest class]], equalToBool(YES));
    assertThat(knight.quest.imageUrl, equalTo([NSURL URLWithString:@"www.foobar.com/quest"]));
}


@end