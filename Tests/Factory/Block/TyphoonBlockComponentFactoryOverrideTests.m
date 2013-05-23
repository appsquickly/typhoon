//
//  TyphoonBlockComponentFactoryOverrideTests.m
//  Typhoon
//
//  Created by Jose Gonzalez Gomez on 17/05/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonSharedComponentFactoryTests.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonBundleResource.h"
#import "ExceptionTestAssembly.h"
#import "MiddleAgesAssemblyOverride.h"
#import "Knight.h"


@interface TyphoonBlockComponentFactoryOverrideTests : TyphoonSharedComponentFactoryTests
@end


@implementation TyphoonBlockComponentFactoryOverrideTests

- (void)setUp
{
    _componentFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[MiddleAgesAssemblyOverride assembly]];
    TyphoonPropertyPlaceholderConfigurer* configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachMutator:configurer];
    [_componentFactory makeDefault];
    
    _exceptionTestFactory = [[TyphoonBlockComponentFactory  alloc] initWithAssembly:[ExceptionTestAssembly assembly]];
}

// This test overrides the same test in the base class, testing for the damselsRescued overrided value in MiddleAgesAssemblyOverride
- (void)test_injects_properties_by_reference_and_by_value
{
    Knight* knight = [_componentFactory componentForKey:@"knight"];
    
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    assertThat([knight.quest questName], equalTo(@"Campaign Quest"));
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(50));
}

- (void)test_injects_properties_by_raw_value
{
    NSDictionary* string = [_componentFactory componentForType:[NSDictionary class]];
//    assertThat(string, notNilValue());
//    assertThat(string, equalTo(@"test string"));
}

@end
