//
// Created by Robert Gilliam on 11/26/13.
//


#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <Typhoon/TyphoonComponentFactory.h>
#import <Typhoon/TyphoonBlockComponentFactory.h>
#import <Typhoon/OCLogTemplate.h>
#import "ExtendedMiddleAgesAssembly.h"
#import "Knight.h"


@interface TyphoonBlockComponentFactory_OverridingTests : SenTestCase
@end


@implementation TyphoonBlockComponentFactory_OverridingTests
{

}

- (void)test_allows_overriding_methods_in_an_assembly
{
    TyphoonComponentFactory* factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[
            [ExtendedMiddleAgesAssembly assembly],
    ]];

    Knight* knight = [(ExtendedMiddleAgesAssembly*) factory yetAnotherKnight];
    LogDebug(@"Knight: %@", knight);
    assertThat(knight, notNilValue());
}


@end