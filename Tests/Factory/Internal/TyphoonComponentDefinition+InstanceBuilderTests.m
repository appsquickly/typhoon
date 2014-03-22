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
#import "PrimitiveMan.h"
#import "TyphoonInjections.h"
#import "TyphoonStringUtils.h"

#define NSValueFromPrimitive(primitive) ([NSValue value:&primitive withObjCType:@encode(typeof(primitive))])


@interface ComponentDefinition_InstanceBuilderTests : SenTestCase
@end

@implementation ComponentDefinition_InstanceBuilderTests
{
    TyphoonComponentFactory *_componentFactory;
}

- (void)setUp
{
    _componentFactory = [[TyphoonComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Initializer injection

- (void)test_injects_required_initializer_dependencies
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonMethod *knightInitializer = [[TyphoonMethod alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameter:@"quest" with:TyphoonInjectionWithReference(@"quest")];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory registerDefinition:knightDefinition];

    TyphoonDefinition *questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory registerDefinition:questDefinition];

    Knight *knight = [_componentFactory buildInstanceWithDefinition:knightDefinition args:nil];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_injects_required_initializer_dependencies_with_factory_method
{
    TyphoonDefinition *urlDefinition = [[TyphoonDefinition alloc] initWithClass:[NSURL class] key:@"url"];
    TyphoonMethod *initializer = [[TyphoonMethod alloc]
        initWithSelector:@selector(URLWithString:)];
    [initializer injectParameterWith:@"http://www.appsquick.ly"];
    [urlDefinition setInitializer:initializer];
    [_componentFactory registerDefinition:urlDefinition];

    NSURL *url = [_componentFactory buildInstanceWithDefinition:urlDefinition args:nil];
    assertThat(url, notNilValue());
}

- (void)test_injects_initializer_value_as_long
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonMethod *initializer = [[TyphoonMethod alloc]
        initWithSelector:@selector(initWithQuest:damselsRescued:)];
    [initializer injectParameter:@"quest" with:nil];
    [initializer injectParameter:@"damselsRescued" with:@(12)];
    [knightDefinition setInitializer:initializer];

    [_componentFactory registerDefinition:knightDefinition];

    Knight *knight = [_componentFactory componentForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_injects_initializer_value_as_collection
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    TyphoonMethod *knightInitializer = [[TyphoonMethod alloc]
        initWithSelector:@selector(initWithQuest:favoriteDamsels:)];
    [knightInitializer injectParameter:@"quest" with:TyphoonInjectionWithReference(@"quest")];

    [knightInitializer injectParameter:@"favoriteDamsels" with:@[
        @"damsel1",
        @"damsel2"
    ]];

    [knightDefinition setInitializer:knightInitializer];

    TyphoonDefinition *questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory registerDefinition:questDefinition];

    [_componentFactory registerDefinition:knightDefinition];

    Knight *knight = [_componentFactory componentForKey:@"knight"];
    assertThatUnsignedLong([knight.favoriteDamsels count], equalToUnsignedLong(2));
}

- (void)test_inject_initializer_values_as_primitives
{
    PrimitiveManStruct *primitiveStruct = malloc(sizeof(PrimitiveManStruct));
    primitiveStruct->fieldA = INT_MAX;
    primitiveStruct->fieldB = LONG_MAX;
    
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[PrimitiveMan class] key:@"primitive"];
    TyphoonMethod *initializer = [[TyphoonMethod alloc] initWithSelector:@selector(initWithIntValue:
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
        selectorValue:
        cstring:
        nsRange:
        pointerValue:
        unknownPointer:
        pointerInsideValue:
        unknownStructure:)];
    [initializer injectParameterWith:@(INT_MAX)];
    [initializer injectParameterWith:@(UINT_MAX)];
    [initializer injectParameterWith:@(SHRT_MAX)];
    [initializer injectParameterWith:@(USHRT_MAX)];
    [initializer injectParameterWith:@(LONG_MAX)];
    [initializer injectParameterWith:@(ULONG_MAX)];
    [initializer injectParameterWith:@(LONG_LONG_MAX)];
    [initializer injectParameterWith:@(ULONG_LONG_MAX)];
    [initializer injectParameterWith:@(UCHAR_MAX)];
    [initializer injectParameterWith:@(FLT_MAX)];
    [initializer injectParameterWith:@(DBL_MAX)];
    [initializer injectParameterWith:@YES];
    [initializer injectParameterWith:@(NSIntegerMax)];
    [initializer injectParameterWith:@(NSUIntegerMax)];
    [initializer injectParameterWith:[self class]];
    [initializer injectParameterWith:NSValueFromPrimitive(@selector(selectorValue))];
     const char *cString = "Hello Typhoon";
    [initializer injectParameterWith:NSValueFromPrimitive(cString)];
    [initializer injectParameterWith:[NSValue valueWithRange:NSMakeRange(10, 20)]];
    [initializer injectParameterWith:[NSValue valueWithPointer:primitiveStruct]];
    [initializer injectParameterWith:[NSValue valueWithPointer:primitiveStruct]];
    [initializer injectParameterWith:[NSValue valueWithPointer:primitiveStruct]];
    PrimitiveManStruct structure;
    structure.fieldA = 23;
    structure.fieldB = LONG_MAX;
    [initializer injectParameterWith:NSValueFromPrimitive(structure)];


    [definition setInitializer:initializer];

    [_componentFactory registerDefinition:definition];
    PrimitiveMan *primitiveMan = [_componentFactory componentForKey:@"primitive"];
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
    assertThatInt(strcmp(primitiveMan.cString, "Hello Typhoon"), equalToInt(0));
    assertThatBool(NSEqualRanges(primitiveMan.nsRange, NSMakeRange(10, 20)), equalToBool(YES));
    assertThatBool(primitiveMan.pointer == primitiveStruct, equalToBool(YES));
    assertThatInt(primitiveMan.unknownPointer->fieldA, equalToInt(INT_MAX));
    assertThatLong(primitiveMan.unknownPointer->fieldB, equalToLong(LONG_MAX));
    assertThat(primitiveMan.pointerInsideValue, equalTo([NSValue valueWithPointer:primitiveStruct]));
    assertThatInt(primitiveMan.unknownStructure.fieldA, equalToInt(23));
    assertThatLong(primitiveMan.unknownStructure.fieldB, equalToLong(LONG_MAX));

    free(primitiveStruct);
}

/* ====================================================================================================================================== */
#pragma mark - Property injection

- (void)test_injects_required_property_dependencies
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(quest) with:TyphoonInjectionWithReference(@"quest")];
    [_componentFactory registerDefinition:knightDefinition];

    TyphoonDefinition *questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory registerDefinition:questDefinition];

    Knight *knight = [_componentFactory buildInstanceWithDefinition:knightDefinition args:nil];
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_raises_exception_if_property_setter_does_not_exist
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(propertyThatDoesNotExist) with:TyphoonInjectionWithReference(@"quest")];
    [_componentFactory registerDefinition:knightDefinition];

    TyphoonDefinition *questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory registerDefinition:questDefinition];

    @try {
        Knight *knight = [_componentFactory buildInstanceWithDefinition:knightDefinition args:nil];
        STFail(@"Should have thrown exception");
        knight = nil;
    }
    @catch (NSException *e) {
        assertThat(e.name, equalTo(@"NSUnknownKeyException"));
    }
}

- (void)test_injects_property_value_as_long
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(damselsRescued) with:@(12)];
    [_componentFactory registerDefinition:knightDefinition];

    Knight *knight = [_componentFactory componentForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_inject_property_value_as_primitives
{
    PrimitiveManStruct *primitiveStruct = malloc(sizeof(PrimitiveManStruct));
    primitiveStruct->fieldA = INT_MAX;
    primitiveStruct->fieldB = LONG_MAX;
    
    char *string = "Hello world";

    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[PrimitiveMan class] key:@"primitive"];
    [definition injectProperty:@selector(intValue) with:@(INT_MAX)];
    [definition injectProperty:@selector(unsignedIntValue) with:@(UINT_MAX)];
    [definition injectProperty:@selector(shortValue) with:@(SHRT_MAX)];
    [definition injectProperty:@selector(unsignedShortValue) with:@(USHRT_MAX)];
    [definition injectProperty:@selector(longValue) with:@(LONG_MAX)];
    [definition injectProperty:@selector(unsignedLongValue) with:@(ULONG_MAX)];
    [definition injectProperty:@selector(longLongValue) with:@(LONG_LONG_MAX)];
    [definition injectProperty:@selector(unsignedLongLongValue) with:@(ULONG_LONG_MAX)];
    [definition injectProperty:@selector(unsignedCharValue) with:@(UCHAR_MAX)];
    [definition injectProperty:@selector(floatValue) with:@(FLT_MAX)];
    [definition injectProperty:@selector(doubleValue) with:@(DBL_MAX)];
    [definition injectProperty:@selector(boolValue) with:@(YES)];
    [definition injectProperty:@selector(integerValue) with:@(NSIntegerMax)];
    [definition injectProperty:@selector(unsignedIntegerValue) with:@(NSUIntegerMax)];
    [definition injectProperty:@selector(classValue) with:[self class]];
    [definition injectProperty:@selector(cString) with:NSValueFromPrimitive(string)];
    [definition injectProperty:@selector(selectorValue) with:[NSValue valueWithPointer:@selector(selectorValue)]];
    [definition injectProperty:@selector(nsRange) with:[NSValue valueWithRange:NSMakeRange(10, 20)]];
    [definition injectProperty:@selector(pointer) with:[NSValue valueWithPointer:&primitiveStruct]];
    [definition injectProperty:@selector(pointerInsideValue) with:[NSValue valueWithPointer:&primitiveStruct]];
    [definition injectProperty:@selector(unknownPointer) with:[NSValue valueWithPointer:primitiveStruct]];
    
    {
        PrimitiveManStruct primitiveStructOnStack;
        primitiveStructOnStack.fieldA = INT_MAX;
        primitiveStructOnStack.fieldB = LONG_MAX;
        [definition injectProperty:@selector(unknownStructure) with:NSValueFromPrimitive(primitiveStructOnStack)];
    }

    [_componentFactory registerDefinition:definition];
    PrimitiveMan *primitiveMan = [_componentFactory componentForKey:@"primitive"];
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
    assertThatBool(NSEqualRanges(primitiveMan.nsRange, NSMakeRange(10, 20)), equalToBool(YES));
    assertThatInt(primitiveMan.unknownPointer->fieldA, equalToInt(INT_MAX));
    assertThatLong(primitiveMan.unknownPointer->fieldB, equalToLong(LONG_MAX));
    assertThatBool(primitiveMan.pointer == &primitiveStruct, equalToBool(YES));
    assertThat(primitiveMan.pointerInsideValue, equalTo([NSValue valueWithPointer:&primitiveStruct]));
    assertThatInt(primitiveMan.unknownStructure.fieldA, equalToInt(INT_MAX));
    assertThatLong(primitiveMan.unknownStructure.fieldB, equalToLong(LONG_MAX));
    STAssertTrue(CStringEquals("Hello world", primitiveMan.cString),nil);
    
    [primitiveMan valueForKey:@"unknownStructure"];
    
    primitiveMan.unknownPointer = NULL;
    free(primitiveStruct);
}


/* ====================================================================================================================================== */
#pragma mark - Property injection error handling

- (void)test_raises_exception_if_property_has_no_setter
{
    @try {
        TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@selector(propertyDoesNotExist) with:@"fooString"];
        [_componentFactory registerDefinition:knightDefinition];

        Knight *knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight); //Suppress unused warning.
        STFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        assertThat(e.name, equalTo(@"NSUnknownKeyException"));
    }

}

/* test_raises_exception_if_property_is_readonly removed, since KVC can set values for read-only properties
 * http://stackoverflow.com/questions/1502708/why-does-a-readonly-property-still-allow-writing-with-kvc  */

@end
