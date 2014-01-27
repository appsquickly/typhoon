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
    [initializer injectParameterNamed:@"quest" withObject:nil];
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
    [initializer injectWithInt:INT_MAX];
    [initializer injectWithUnsignedInt:UINT_MAX];
    [initializer injectWithShort:SHRT_MAX];
    [initializer injectWithUnsignedShort:USHRT_MAX];
    [initializer injectWithLong:LONG_MAX];
    [initializer injectWithUnsignedLong:ULONG_MAX];
    [initializer injectWithLongLong:LONG_LONG_MAX];
    [initializer injectWithUnsignedLongLong:ULONG_LONG_MAX];
    [initializer injectWithUnsignedChar:UCHAR_MAX];
    [initializer injectWithFloat:FLT_MAX];
    [initializer injectWithDouble:DBL_MAX];
    [initializer injectWithBool:YES];
    [initializer injectWithInteger:NSIntegerMax];
    [initializer injectWithUnsignedInteger:NSUIntegerMax];
    [initializer injectWithClass:[self class]];
    [initializer injectWithSelector:@selector(selectorValue)];

    [definition setInitializer:initializer];

    [_componentFactory register:definition];
    PrimitiveMan* primitiveMan = [_componentFactory componentForKey:@"primitive"];
    assertThatInt(primitiveMan.intValue, equalToInt(INT_MAX));
    assertThatUnsignedInt(primitiveMan.unsignedIntValue, equalToUnsignedInt(UINT_MAX));
    assertThatShort(primitiveMan.shortValue, equalToShort(SHRT_MAX));
    assertThatUnsignedShort(primitiveMan.unsignedShortValue, equalToUnsignedShort(USHRT_MAX));
    assertThatLong(primitiveMan.longValue, equalToLong(LONG_MAX));
    assertThatUnsignedLong(primitiveMan.unsignedLongValue, equalToUnsignedLong(ULONG_MAX));
    assertThatLongLong(primitiveMan.longLongValue, equalToLongLong(LONG_LONG_MAX));
    assertThatUnsignedLongLong(primitiveMan.unsignedLongLongValue, equalToUnsignedLongLong(ULONG_LONG_MAX));
    assertThatUnsignedChar(primitiveMan.unsignedCharValue, equalToUnsignedChar(UCHAR_MAX));
    assertThatFloat(primitiveMan.floatValue, equalToFloat(FLT_MAX));
    assertThatDouble(primitiveMan.doubleValue, equalToDouble(DBL_MAX));
    assertThatBool(primitiveMan.boolValue, equalToBool(YES));
    assertThatInteger(primitiveMan.integerValue, equalToInteger(NSIntegerMax));
    assertThatUnsignedInteger(primitiveMan.unsignedIntegerValue, equalToUnsignedInteger(NSUIntegerMax));
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
        assertThat(e.name, equalTo(@"NSUnknownKeyException"));
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
    PrimitiveManStruct *primitiveStruct = malloc(sizeof(PrimitiveManStruct));
    primitiveStruct->fieldA = INT_MAX;
    primitiveStruct->fieldB = LONG_MAX;
    
    TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:[PrimitiveMan class] key:@"primitive"];
    [definition injectProperty:@selector(intValue) withObjectInstance:@(INT_MAX)];
    [definition injectProperty:@selector(unsignedIntValue) withObjectInstance:@(UINT_MAX)];
    [definition injectProperty:@selector(shortValue) withObjectInstance:@(SHRT_MAX)];
    [definition injectProperty:@selector(unsignedShortValue) withObjectInstance:@(USHRT_MAX)];
    [definition injectProperty:@selector(longValue) withObjectInstance:@(LONG_MAX)];
    [definition injectProperty:@selector(unsignedLongValue) withObjectInstance:@(ULONG_MAX)];
    [definition injectProperty:@selector(longLongValue) withObjectInstance:@(LONG_LONG_MAX)];
    [definition injectProperty:@selector(unsignedLongLongValue) withObjectInstance:@(ULONG_LONG_MAX)];
    [definition injectProperty:@selector(unsignedCharValue) withObjectInstance:@(UCHAR_MAX)];
    [definition injectProperty:@selector(floatValue) withObjectInstance:@(FLT_MAX)];
    [definition injectProperty:@selector(doubleValue) withObjectInstance:@(DBL_MAX)];
    [definition injectProperty:@selector(boolValue) withObjectInstance:@(YES)];
    [definition injectProperty:@selector(integerValue) withObjectInstance:@(NSIntegerMax)];
    [definition injectProperty:@selector(unsignedIntegerValue) withObjectInstance:@(NSUIntegerMax)];
    [definition injectProperty:@selector(classValue) withObjectInstance:[self class]];
    [definition injectProperty:@selector(cString) withValueAsText:@"cStringText"];
    [definition injectProperty:@selector(cgRect) withObjectInstance:[NSValue valueWithCGRect:CGRectMake(10, 15, 20, 30)]];
    [definition injectProperty:@selector(pointer) withObjectInstance:[NSValue valueWithPointer:&primitiveStruct]];
    [definition injectProperty:@selector(pointerInsideValue) withObjectInstance:[NSValue valueWithPointer:&primitiveStruct]];
    [definition injectProperty:@selector(unknownPointer) withObjectInstance:[NSValue valueWithPointer:primitiveStruct]];
    
    
    [_componentFactory register:definition];
    PrimitiveMan* primitiveMan = [_componentFactory componentForKey:@"primitive"];
    assertThatInt(primitiveMan.intValue, equalToInt(INT_MAX));
    assertThatUnsignedInt(primitiveMan.unsignedIntValue, equalToUnsignedInt(UINT_MAX));
    assertThatShort(primitiveMan.shortValue, equalToShort(SHRT_MAX));
    assertThatUnsignedShort(primitiveMan.unsignedShortValue, equalToUnsignedShort(USHRT_MAX));
    assertThatLong(primitiveMan.longValue, equalToLong(LONG_MAX));
    assertThatUnsignedLong(primitiveMan.unsignedLongValue, equalToUnsignedLong(ULONG_MAX));
    assertThatLongLong(primitiveMan.longLongValue, equalToLongLong(LONG_LONG_MAX));
    assertThatUnsignedLongLong(primitiveMan.unsignedLongLongValue, equalToUnsignedLongLong(ULONG_LONG_MAX));
    assertThatUnsignedChar(primitiveMan.unsignedCharValue, equalToUnsignedChar(UCHAR_MAX));
    assertThatFloat(primitiveMan.floatValue, equalToFloat(FLT_MAX));
    assertThatDouble(primitiveMan.doubleValue, equalToDouble(DBL_MAX));
    assertThatBool(primitiveMan.boolValue, equalToBool(YES));
    assertThatInteger(primitiveMan.integerValue, equalToInteger(NSIntegerMax));
    assertThatUnsignedInteger(primitiveMan.unsignedIntegerValue, equalToUnsignedInteger(NSUIntegerMax));
    assertThat(NSStringFromClass(primitiveMan.classValue), equalTo(NSStringFromClass([self class])));
    assertThatInt(strcmp(primitiveMan.cString, "cStringText"), equalToInt(0));
    assertThatBool(CGRectEqualToRect(primitiveMan.cgRect, CGRectMake(10, 15, 20, 30)), equalToBool(YES));
    assertThatInt(primitiveMan.unknownPointer->fieldA, equalToInt(INT_MAX));
    assertThatInt(primitiveMan.unknownPointer->fieldB, equalToInt(LONG_MAX));
    assertThatBool(primitiveMan.pointer == &primitiveStruct, equalToBool(YES));
    assertThat(primitiveMan.pointerInsideValue, equalTo([NSValue valueWithPointer:&primitiveStruct]));
    
    primitiveMan.unknownPointer = NULL;
    free(primitiveStruct);
}


/* ====================================================================================================================================== */
#pragma mark - Property injection error handling

- (void) test_raises_exception_if_property_has_no_setter
{
    @try
    {
        TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@selector(propertyDoesNotExist) withObjectInstance:@"fooString"];
        [_componentFactory register:knightDefinition];

        Knight* knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight); //Suppress unused warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat(e.name, equalTo(@"NSUnknownKeyException"));
    }

}

/* test_raises_exception_if_property_is_readonly removed, since KVC can set values for read-only properties
 * http://stackoverflow.com/questions/1502708/why-does-a-readonly-property-still-allow-writing-with-kvc  */

@end
