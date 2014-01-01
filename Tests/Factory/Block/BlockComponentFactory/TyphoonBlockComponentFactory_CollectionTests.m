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
#import "MiddleAgesAssembly.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "TyphoonAssemblyAdviser.h"


@interface TyphoonBlockComponentFactory_CollectionTests : SenTestCase
@end


@implementation TyphoonBlockComponentFactory_CollectionTests
{

}

- (void)test_allows_initialization_with_a_collection_of_assemblies
{
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
            [MiddleAgesAssembly assembly],
            [CollaboratingMiddleAgesAssembly assembly],
    ]];

    Knight* knight = [(CollaboratingMiddleAgesAssembly*) factory knightWithExternalQuest];
    [CollaboratingMiddleAgesAssembly verifyKnightWithExternalQuest:knight];
}

- (void)test_allows_initialization_with_a_collection_of_assemblies_in_any_order
{
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
            [CollaboratingMiddleAgesAssembly assembly],
            [MiddleAgesAssembly assembly]
    ]];

    Knight* knight = [(CollaboratingMiddleAgesAssembly*) factory knightWithExternalQuest];
    [CollaboratingMiddleAgesAssembly verifyKnightWithExternalQuest:knight];
}

// Can't accurately test this here because with ARC we can't control whether the factory and assembly are deallocated before or after we check!
//- (void)test_dealloc_cleans_up_method_advising
//{
//    MiddleAgesAssembly* assembly = [MiddleAgesAssembly assembly];
//    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[assembly]];
//    factory = nil;
//    assembly = nil;
//
//    STAssertFalse([TyphoonAssemblyAdviser assemblyClassIsAdvised:[MiddleAgesAssembly class]], nil);
//}

@end
