////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "Typhoon.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonParameterInjectedAsCollection.h"
#import "PrimitiveMan.h"

@interface ComponentDefinition_InstanceBuilderTests : SenTestCase
@end

@implementation ComponentDefinition_InstanceBuilderTests
{
    TyphoonComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[TyphoonComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Initializer injection

- (void)test_injects_required_initializer_dependencies
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonInitializer* knightInitializer = [[TyphoonInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_injects_required_initializer_dependencies_with_factory_method
{
    TyphoonDefinition* urlDefinition = [[TyphoonDefinition alloc] initWithClass:[NSURL class] key:@"url"];
    TyphoonInitializer* initializer = [[TyphoonInitializer alloc]
            initWithSelector:@selector(URLWithString:) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodYes];
    [initializer injectParameterAtIndex:0 withValueAsText:@"http://www.appsquick.ly" requiredTypeOrNil:[NSString class]];
    [urlDefinition setInitializer:initializer];
    [_componentFactory register:urlDefinition];

    NSURL* url = [_componentFactory buildInstanceWithDefinition:urlDefinition];
    assertThat(url, notNilValue());
}

- (void)test_injects_initializer_value_as_long
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonInitializer
            * initializer = [[TyphoonInitializer alloc]
            initWithSelector:@selector(initWithQuest:damselsRescued:) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodNo];
    [initializer injectParameterNamed:@"damselsRescued" withValueAsText:@"12" requiredTypeOrNil:nil];
    [knightDefinition setInitializer:initializer];

    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory componentForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_injects_initializer_value_as_collection
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonInitializer
            * knightInitializer = [[TyphoonInitializer alloc]
            initWithSelector:@selector(initWithQuest:favoriteDamsels:) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodNo];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightInitializer injectParameterNamed:@"favoriteDamsels" asCollection:^(TyphoonParameterInjectedAsCollection* asCollection)
    {
        [asCollection addItemWithText:@"damsel1" requiredType:[NSString class]];
        [asCollection addItemWithText:@"damsel2" requiredType:[NSString class]];
    } requiredType:[NSArray class]];

    [knightDefinition setInitializer:knightInitializer];

    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory componentForKey:@"knight"];
    assertThatUnsignedLong([knight.favoriteDamsels count], equalToUnsignedLong(2));
}

- (void)test_inject_initializer_values_as_primitives
{
    TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:[PrimitiveMan class] key:@"primitive"];
    TyphoonInitializer* initializer = [[TyphoonInitializer alloc] initWithSelector:@selector(
                                                                                             initWithIntValue:
                                                                                             unsignedIntValue:
                                                                                             shortValue:
                                                                                             unsignedShortValue:
                                                                                             longValue:
                                                                                             unsignedLongValue:
                                                                                             longLongValue:
                                                                                             unsignedLongLongValue:
                                                                                             unsignedCharValue:
                                                                                             floatValue:
                                                                                             doubleValue:
                                                                                             boolValue:
                                                                                             integerValue:
                                                                                             unsignedIntegerValue:
                                                                                             classValue:
                                                                                             selectorValue:)];
    [initializer injectWithInt:1];
    [initializer injectWithUnsignedInt:2];
    [initializer injectWithShort:3];
    [initializer injectWithUnsignedShort:4];
    [initializer injectWithLong:5];
    [initializer injectWithUnsignedLong:6];
    [initializer injectWithLongLong:7];
    [initializer injectWithUnsignedLongLong:8];
    [initializer injectWithUnsignedChar:9];
    [initializer injectWithFloat:10.0];
    [initializer injectWithDouble:11.0];
    [initializer injectWithBool:YES];
    [initializer injectWithInteger:NSIntegerMax];
    [initializer injectWithUnsignedInteger:NSUIntegerMax];
    [initializer injectWithClass:[self class]];
    [initializer injectWithSelector:@selector(selectorValue)];

    [definition setInitializer:initializer];

    [_componentFactory register:definition];
    PrimitiveMan* primitiveMan = [_componentFactory componentForKey:@"primitive"];
    assertThatInt(primitiveMan.intValue, equalToInt(1));
    assertThatUnsignedInt(primitiveMan.unsignedIntValue, equalToUnsignedInt(2));
    assertThatShort(primitiveMan.shortValue, equalToShort(3));
    assertThatUnsignedShort(primitiveMan.unsignedShortValue, equalToUnsignedShort(4));
    assertThatLong(primitiveMan.longValue, equalToLong(5));
    assertThatUnsignedLong(primitiveMan.unsignedLongValue, equalToUnsignedLong(6));
    assertThatLongLong(primitiveMan.longLongValue, equalToLongLong(7));
    assertThatUnsignedLongLong(primitiveMan.unsignedLongLongValue, equalToUnsignedLongLong(8));
    assertThatUnsignedChar(primitiveMan.unsignedCharValue, equalToUnsignedChar(9));
    assertThatFloat(primitiveMan.floatValue, equalToFloat(10.0));
    assertThatDouble(primitiveMan.doubleValue, equalToDouble(11.0));
    assertThatBool(primitiveMan.boolValue, equalToBool(YES));
    assertThatInteger(primitiveMan.integerValue, equalToInteger(NSIntegerMax));
 //   assertThatUnsignedInteger(primitiveMan.unsignedIntegerValue, equalToUnsignedInteger(NSUIntegerMax));
    assertThat(NSStringFromClass(primitiveMan.classValue), equalTo(NSStringFromClass([self class])));
    assertThat(NSStringFromSelector(primitiveMan.selectorValue), equalTo(NSStringFromSelector(@selector(selectorValue))));
}

/* ====================================================================================================================================== */
#pragma mark - Property injection

- (void)test_injects_required_property_dependencies
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(quest) withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_raises_exception_if_property_setter_does_not_exist
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(propertyThatDoesNotExist) withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    @try
    {
        Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
        STFail(@"Should have thrown exception");
        knight = nil;
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
                @"Tried to inject property 'propertyThatDoesNotExist' on object of type 'Knight', but the instance has no setter for this property."));
    }
}

- (void)test_injects_property_value_as_long
{
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(damselsRescued) withValueAsText:@"12"];
    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory componentForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_inject_property_value_as_primitives
{
    TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:[PrimitiveMan class] key:@"primitive"];
    [definition injectProperty:@selector(intValue) withInt:1];
    [definition injectProperty:@selector(unsignedIntValue) withUnsignedInt:2];
    [definition injectProperty:@selector(shortValue) withShort:3];
    [definition injectProperty:@selector(unsignedShortValue) withUnsignedShort:4];
    [definition injectProperty:@selector(longValue) withLong:5];
    [definition injectProperty:@selector(unsignedLongValue) withUnsignedLong:6];
    [definition injectProperty:@selector(longLongValue) withLongLong:7];
    [definition injectProperty:@selector(unsignedLongLongValue) withUnsignedLongLong:8];
    [definition injectProperty:@selector(unsignedCharValue) withUnsignedChar:9];
    [definition injectProperty:@selector(floatValue) withFloat:10.101010];
    [definition injectProperty:@selector(doubleValue) withDouble:11.111111];
    [definition injectProperty:@selector(boolValue) withBool:YES];
    [definition injectProperty:@selector(integerValue) withInteger:NSIntegerMax];
    [definition injectProperty:@selector(unsignedIntegerValue) withUnsignedInteger:NSUIntegerMax];
    [definition injectProperty:@selector(classValue) withClass:[self class]];
    [definition injectProperty:@selector(selectorValue) withSelector:@selector(selectorValue)];
    
    [_componentFactory register:definition];
    PrimitiveMan* primitiveMan = [_componentFactory componentForKey:@"primitive"];
    assertThatInt(primitiveMan.intValue, equalToInt(1));
    assertThatUnsignedInt(primitiveMan.unsignedIntValue, equalToUnsignedInt(2));
    assertThatShort(primitiveMan.shortValue, equalToShort(3));
    assertThatUnsignedShort(primitiveMan.unsignedShortValue, equalToUnsignedShort(4));
    assertThatLong(primitiveMan.longValue, equalToLong(5));
    assertThatUnsignedLong(primitiveMan.unsignedLongValue, equalToUnsignedLong(6));
    assertThatLongLong(primitiveMan.longLongValue, equalToLongLong(7));
    assertThatUnsignedLongLong(primitiveMan.unsignedLongLongValue, equalToUnsignedLongLong(8));
    assertThatUnsignedChar(primitiveMan.unsignedCharValue, equalToUnsignedChar(9));
    assertThatFloat(primitiveMan.floatValue, equalToFloat(10.101010));
    assertThatDouble(primitiveMan.doubleValue, equalToDouble(11.111111));
    assertThatBool(primitiveMan.boolValue, equalToBool(YES));
    assertThatInteger(primitiveMan.integerValue, equalToInteger(NSIntegerMax));
//    assertThatUnsignedInteger(primitiveMan.unsignedIntegerValue, equalToUnsignedInteger(NSUIntegerMax));
    assertThat(NSStringFromClass(primitiveMan.classValue), equalTo(NSStringFromClass([self class])));
    assertThat(NSStringFromSelector(primitiveMan.selectorValue), equalTo(NSStringFromSelector(@selector(selectorValue))));
}


/* ====================================================================================================================================== */
#pragma mark - Property injection error handling

- (void)test_raises_exception_if_property_has_no_setter
{
    @try
    {
        TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@selector(propertyDoesNotExist) withReference:@"quest"];
        [_componentFactory register:knightDefinition];

        Knight* knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight); //Suppress unused warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
                @"Tried to inject property 'propertyDoesNotExist' on object of type 'Knight', but the instance has no setter for this property."));
    }

}

- (void)test_raises_exception_if_property_is_readonly
{
    @try
    {
        TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@selector(readOnlyQuest) withReference:@"quest"];
        [_componentFactory register:knightDefinition];

        TyphoonDefinition* questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
        [_componentFactory register:questDefinition];

        Knight* knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight); //suppress unused warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property 'readOnlyQuest' of class 'Knight' is readonly."));
    }
}

@end
