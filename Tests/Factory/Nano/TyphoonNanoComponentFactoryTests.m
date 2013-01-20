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
#import "TyphoonNanoComponentFactory.h"
#import "TyphoonAssembly.h"
#import "MiddleAgesAssembly.h"

@interface TyphoonNanoComponentFactoryTests : SenTestCase
@end

@implementation TyphoonNanoComponentFactoryTests
{
    TyphoonComponentFactory* _factory;
}

- (void)setUp
{
    _factory = [[TyphoonNanoComponentFactory alloc] initWithAssembly:[MiddleAgesAssembly assembly]];
}

- (void)test_registers_category_definitions
{
    Knight* knight = [_factory componentForType:[Knight class]];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    NSLog(@"#################### Knight: %@", knight);
}



@end

