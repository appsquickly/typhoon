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
#import <Typhoon/TyphoonAssemblyAdviser.h>
#import <Typhoon/TyphoonAssembly.h>

@interface TyphoonAssemblyAdviserTests : SenTestCase
@end


@implementation TyphoonAssemblyAdviserTests
{

}

- (void)testInit
{
    TyphoonAssemblyAdviser* adviser = [[TyphoonAssemblyAdviser alloc] init];

}

- (void)testInitWithAssembly
{
    TyphoonAssembly *assembly = [[TyphoonAssembly alloc] init];
    TyphoonAssemblyAdviser* adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];
}

- (void)testEnumeratesDefinitionSelectors
{
    TyphoonAssembly *assembly = [[TyphoonAssembly alloc] init];
    TyphoonAssemblyAdviser* adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    NSSet *selectors = [adviser enumerateDefinitionSelectors];
    assertThat(selectors, empty());
}

@end