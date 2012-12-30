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
#import "ClassADependsOnB.h"
#import "ClassBDependsOnA.h"


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

- (void)test_mixed_initializer_and_property_injection
{
    Knight* anotherKnight = [_componentFactory objectForKey:@"anotherKnight"];
    LogDebug(@"Here's another knight: %@", anotherKnight);
    assertThat(anotherKnight.quest, notNilValue());
    assertThatBool(anotherKnight.hasHorseWillTravel, equalToBool(YES));
    _componentFactory = nil;
}

- (void)test_factory_method_injection
{
    NSURL* url = [_componentFactory objectForKey:@"serviceUrl"];
    LogDebug(@"Here's the url: %@", url);
}

- (void)test_factory_method_injection_raises_exception_if_required_class_not_set
{
    @try
    {
        NSURL* url = [_componentFactory objectForKey:@"anotherServiceUrl"];
        LogDebug(@"Here's the url: %@", url);
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
            @"Unless the type is primitive (int, BOOL, etc), initializer injection requires the required class to be specified. Eg: <argument parameterName=\"string\" value=\"http://dev.foobar.com/service/\" required-class=\"NSString\" />"));
    }

}

- (void)test_prevents_circular_dependencies_by_reference
{
    SpringXmlComponentFactory* factory = [[SpringXmlComponentFactory alloc] initWithConfigFileName:@"CircularDependenciesAssembly.xml"];

    @try
    {
        ClassADependsOnB* classA = [factory objectForKey:@"classA"];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Circular dependency detected: {(\n    classB,\n    classA\n)}"));
    }
}

- (void)test_prevents_circular_dependencies_by_type
{
    SpringXmlComponentFactory* factory = [[SpringXmlComponentFactory alloc] initWithConfigFileName:@"CircularDependenciesAssembly.xml"];

    @try
    {
        ClassADependsOnB* classA = [factory objectForType:[ClassADependsOnB class]];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Circular dependency detected: {(\n    classB,\n    classA\n)}"));
    }
}

@end
