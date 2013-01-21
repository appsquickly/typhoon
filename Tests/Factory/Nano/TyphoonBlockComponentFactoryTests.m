////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonComponentFactory.h"
#import "Knight.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "MiddleAgesAssembly.h"

@interface TyphoonBlockComponentFactoryTests : SenTestCase
@end

@implementation TyphoonBlockComponentFactoryTests
{
    TyphoonComponentFactory* _factory;
}

- (void)setUp
{
    _factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[MiddleAgesAssembly assembly]];
}

- (void)test_resolves_from_assembly
{
    Knight* knight = [_factory componentForKey:@"basicKnight"];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    NSLog(@"#################### Knight: %@", knight);
}

- (void)test_resolves_from_assembly2
{
    Knight* knight = [_factory componentForKey:@"basicKnight"];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    NSLog(@"#################### Knight: %@", knight);
}

- (void)test_resolves_from_assembly3
{
    Knight* knight = [_factory componentForKey:@"basicKnight"];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    NSLog(@"#################### Knight: %@", knight);
}


- (void)test_returns_component_with_assembly_selector
{
    Knight* knight = [(MiddleAgesAssembly*) _factory basicKnight];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    NSLog(@"#################### Knight: %@", knight);
}

- (void)test_returns_cavalryMan
{
    Knight* knight = [(MiddleAgesAssembly*) _factory cavalryMan];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    NSLog(@"#################### Knight: %@", knight);
}


@end

