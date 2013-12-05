//
// Created by Robert Gilliam on 11/26/13.
//


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

    // this test succeeds if run when MiddleAgesAssembly has previously been registered with a component factory (and its methods swizzled), but fails otherwise (say, if run alone).
    STFail(@"This test erroneously succeeds when run alongside any other unit tests, but fails when run alone.");
}

- (void)test_allows_initialization_with_a_hardcoded_collection_of_assemblies
{
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
            [MiddleAgesAssembly assembly],
            [CollaboratingMiddleAgesAssembly assembly],
    ]];

    Knight* knight = [(CollaboratingMiddleAgesAssembly*) factory knightWithExternalHardcodedQuest];
    [CollaboratingMiddleAgesAssembly verifyKnightWithExternalQuest:knight];
}

- (void)test_allows_initialization_with_a_hardcoded_collection_of_assemblies_in_any_order
{
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
            [CollaboratingMiddleAgesAssembly assembly],
            [MiddleAgesAssembly assembly],
    ]];

    Knight* knight = [(CollaboratingMiddleAgesAssembly*) factory knightWithExternalHardcodedQuest];
    [CollaboratingMiddleAgesAssembly verifyKnightWithExternalQuest:knight];

    // this test succeeds if run when MiddleAgesAssembly has previously been registered with a component factory (and its methods swizzled), but fails otherwise (say, if run alone).
    STFail(@"This test erroneously succeeds when run alongside any other unit tests, but fails when run alone.");
}

- (void)test_dealloc_does_not_unswizzle
{
    MiddleAgesAssembly* assembly = [MiddleAgesAssembly assembly];
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[assembly]];
    factory = nil;

    STAssertTrue([TyphoonAssemblyAdviser assemblyMethodsSwizzled:assembly], nil);
}

@end