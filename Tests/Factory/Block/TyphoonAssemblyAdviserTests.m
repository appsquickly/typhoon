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
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssembly.h"
#import "TyphoonWrappedSelector.h"



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

}

- (void)testEnumeratesDefinitionSelectors_EmptyAssembly
{
    EmptyTestAssembly *assembly = [[EmptyTestAssembly alloc] init];
    TyphoonAssemblyAdviser* adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    NSSet *selectors = [adviser enumerateDefinitionSelectors];
    assertThat(selectors, empty());
}

- (void)testEnumeratesDefinitionSelectors_Assembly
{
    TestAssemblyWithMethod *assembly = [[TestAssemblyWithMethod alloc] init];
    TyphoonAssemblyAdviser* adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    NSSet *selectors = [adviser enumerateDefinitionSelectors];
    TyphoonWrappedSelector *wrappedSEL = [TyphoonWrappedSelector wrappedSelectorWithName:@"aDefinitionMethod"];

    assertThat(selectors, onlyContains(wrappedSEL, nil));
}

@end