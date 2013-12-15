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


@interface TestAssembly : TyphoonAssembly
@end

@implementation TestAssembly
@end


@interface TyphoonAssemblyAdviserTests : SenTestCase
@end



@interface TestAssembly(TyphoonAssemblyAdviserTests)

- (void)addDefinitionMethodNamed:(NSString *)methodName;

@end

@implementation TestAssembly(TyphoonAssemblyAdviserTests)

- (void)addDefinitionMethodNamed:(NSString*)methodName
{
    IMP imp = imp_implementationWithBlock(^{});

    class_addMethod([self class], NSSelectorFromString(methodName), imp, "v@:");
}

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

- (void)testEnumeratesDefinitionSelectors_EmptyAssembly
{
    TyphoonAssembly *assembly = [[TyphoonAssembly alloc] init];
    TyphoonAssemblyAdviser* adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];

    NSSet *selectors = [adviser enumerateDefinitionSelectors];
    assertThat(selectors, empty());
}

//- (void)testEnumeratesDefinitionSelectors_Assembly
//{
//    TestAssembly *assembly = [[TestAssembly alloc] init];
//    [assembly addDefinitionMethodNamed:@"aDefinitionMethod"];
//
//    TyphoonAssemblyAdviser* adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:assembly];
//
//    NSSet *selectors = [adviser enumerateDefinitionSelectors];
//    TyphoonWrappedSelector *wrappedSEL = [TyphoonWrappedSelector withName:@"aDefinitionMethod"];
//
//    // <TyphoonWrappedSelector: 0x00000 SEL named: 'aDefinitionMethod'>
//    // Expected a collection containing items matching (<Pointer value of SEL named 'aDefinitionMethod'>), but was <{(
//    // description!
//    // replace NSValue with an abstraction.
//    // TyphoonWrappedSelector
//
//    assertThat(selectors, onlyContains(wrappedSEL, nil));
//}

@end