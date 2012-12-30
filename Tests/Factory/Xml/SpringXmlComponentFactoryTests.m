////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "SpringXmlComponentFactory.h"
#import "Knight.h"


@interface SpringXmlComponentFactoryTests : SenTestCase
@end

@implementation SpringXmlComponentFactoryTests
{
    SpringXmlComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[SpringXmlComponentFactory alloc] initWithConfigFileName:@"MiddleAgesAssembly.xml"];
}

- (void)test_property_injection
{
    Knight* knight = [_componentFactory objectForKey:@"knight"];

    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
    assertThat([knight.quest questName], equalTo(@"Campaign Quest"));
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));


}

- (void)test_initializer_injection
{
    Knight* anotherKnight = [_componentFactory objectForKey:@"anotherKnight"];
    LogDebug(@"Here's another knight: %@", anotherKnight);
    assertThat(anotherKnight.quest, notNilValue());
}

//- (void)test_factory_method_injection
//{
//    NSURL* url =[_componentFactory objectForKey:@"serviceUrl"];
//    LogDebug(@"Here's the url: %@", url);
//}


@end
