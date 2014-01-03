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
#import <objc/runtime.h>
#import "TyphoonAssemblySelectorAdviser.h"
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssembly.h"
#import "TyphoonSelector.h"
#import "TyphoonTestMethodSwizzler.h"
#import "TyphoonJRMethodSwizzler.h"


@interface EmptyTestAssembly : TyphoonAssembly
@end

@implementation EmptyTestAssembly
@end



@interface TestAssemblyWithMethod : EmptyTestAssembly
@end

@implementation TestAssemblyWithMethod

- (void)aDefinitionMethod
{

}

@end



@interface TyphoonAssemblyAdviserTests : SenTestCase
@end


@implementation TyphoonAssemblyAdviserTests
{
    TyphoonAssemblyAdviser* adviser;

    TyphoonAssembly *assembly;
}

- (void)testEnumeratesDefinitionSelectors_EmptyAssembly
{
    assembly = [[EmptyTestAssembly alloc] init];
    adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    NSSet *selectors = [adviser enumerateDefinitionSelectors];
    assertThat(selectors, empty());
}

- (void)testEnumeratesDefinitionSelectors_AssemblyWithMethod
{
    assembly = [[TestAssemblyWithMethod alloc] init];
    adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    NSSet *selectors = [adviser enumerateDefinitionSelectors];
    TyphoonSelector*theSelector = [TyphoonSelector selectorWithName:@"aDefinitionMethod"];

    assertThat(selectors, onlyContains(theSelector, nil));
}

- (void)testAdvisesAssembly
{
    assembly = [[TestAssemblyWithMethod alloc] init];
    adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    TyphoonTestMethodSwizzler* swizzler = [[TyphoonTestMethodSwizzler alloc] init];
    adviser.swizzler = swizzler;

    [adviser adviseAssembly];

    NSString *advisedName = [TyphoonAssemblySelectorAdviser advisedNameForName:@"aDefinitionMethod"];
    [swizzler assertExchangedImplementationsFor:@"aDefinitionMethod" with:advisedName onClass:[assembly class]];
}

- (void)testConfiguresItselfWithARealSwizzler
{
    assembly = [[TestAssemblyWithMethod alloc] init];
    adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    assertThat([adviser swizzler], instanceOf([TyphoonJRMethodSwizzler class]));
}

@end