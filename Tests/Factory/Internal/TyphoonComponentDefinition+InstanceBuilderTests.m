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

#import <XCTest/XCTest.h>
#import "Typhoon.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "PrimitiveMan.h"
#import "TyphoonInjections.h"
#import "TyphoonUtils.h"

#define NSValueFromPrimitive(primitive) ([NSValue value:&primitive withObjCType:@encode(typeof(primitive))])


@interface ComponentDefinition_InstanceBuilderTests : XCTestCase
@end

@implementation ComponentDefinition_InstanceBuilderTests
{
    TyphoonComponentFactory *_componentFactory;
}

- (void)setUp
{
    _componentFactory = [[TyphoonComponentFactory alloc] init];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initializer injection

- (void)test_injects_required_initializer_dependencies
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition useInitializer:@selector(initWithQuest:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:TyphoonInjectionWithReference(@"quest")];
    }];
    [_componentFactory registerDefinition:knightDefinition];

    TyphoonDefinition *questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory registerDefinition:questDefinition];

    Knight *knight = [_componentFactory buildInstanceWithDefinition:knightDefinition args:nil];
    XCTAssertNotNil(knight);
    XCTAssertNotNil(knight.quest);
}

- (void)test_injects_required_initializer_dependencies_with_factory_method
{
    TyphoonDefinition *urlDefinition = [[TyphoonDefinition alloc] initWithClass:[NSURL class] key:@"url"];
    [urlDefinition useInitializer:@selector(URLWithString:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:@"http://www.appsquick.ly"];
    }];
    [_componentFactory registerDefinition:urlDefinition];

    NSURL *url = [_componentFactory buildInstanceWithDefinition:urlDefinition args:nil];
    XCTAssertNotNil(url);
}

- (void)test_injects_initializer_value_as_long
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition useInitializer:@selector(initWithQuest:damselsRescued:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:nil];
        [initializer injectParameterWith:@(12)];
    }];

    [_componentFactory registerDefinition:knightDefinition];

    Knight *knight = [_componentFactory componentForKey:@"knight"];
    XCTAssertEqual(knight.damselsRescued, 12);
}

- (void)test_injects_initializer_value_as_collection
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];


    [knightDefinition useInitializer:@selector(initWithQuest:favoriteDamsels:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:TyphoonInjectionWithReference(@"quest")];
        [initializer injectParameterWith:@[
                @"damsel1",
                @"damsel2"
        ]];
    }];

    TyphoonDefinition *questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory registerDefinition:questDefinition];

    [_componentFactory registerDefinition:knightDefinition];

    Knight *knight = [_componentFactory componentForKey:@"knight"];
    XCTAssertEqual([knight.favoriteDamsels count], 2);
}

- (void)test_inject_initializer_values_as_primitives
{
    PrimitiveManStruct *primitiveStruct = malloc(sizeof(PrimitiveManStruct));
    primitiveStruct->fieldA = INT32_MAX;
    primitiveStruct->fieldB = INT64_MAX;
    
    TyphoonDefinition *definition = [[TyphoonDefinition alloc] initWithClass:[PrimitiveMan class] key:@"primitive"];
    [definition useInitializer:@selector(initWithIntValue:
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
            unknownStructure:) parameters:^(TyphoonMethod *initializer) {
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
        structure.fieldB = INT64_MAX;
        [initializer injectParameterWith:NSValueFromPrimitive(structure)];
    }];

    [_componentFactory registerDefinition:definition];
    PrimitiveMan *primitiveMan = [_componentFactory componentForKey:@"primitive"];
    XCTAssertEqual(primitiveMan.intValue, INT_MAX);
    XCTAssertEqual(primitiveMan.unsignedIntValue, UINT_MAX);
    XCTAssertEqual(primitiveMan.shortValue, SHRT_MAX);
    XCTAssertEqual(primitiveMan.unsignedShortValue, USHRT_MAX);
    XCTAssertEqual(primitiveMan.longValue, LONG_MAX);
    XCTAssertEqual(primitiveMan.unsignedLongValue, ULONG_MAX);
    XCTAssertEqual(primitiveMan.longLongValue, LONG_LONG_MAX);
    XCTAssertEqual(primitiveMan.unsignedLongLongValue, ULONG_LONG_MAX);
    XCTAssertEqual(primitiveMan.unsignedCharValue, UCHAR_MAX);
    XCTAssertEqual(primitiveMan.floatValue, FLT_MAX);
    XCTAssertEqual(primitiveMan.doubleValue, DBL_MAX);
    XCTAssertEqual(primitiveMan.boolValue, YES);
    XCTAssertEqual(primitiveMan.integerValue, NSIntegerMax);
    XCTAssertEqual(primitiveMan.unsignedIntegerValue, NSUIntegerMax);
    XCTAssertEqualObjects(NSStringFromClass(primitiveMan.classValue), NSStringFromClass([self class]));
    XCTAssertEqualObjects(NSStringFromSelector(primitiveMan.selectorValue), NSStringFromSelector(@selector(selectorValue)));
    XCTAssertEqual(strcmp(primitiveMan.cString, "Hello Typhoon"), 0);
    XCTAssertTrue(NSEqualRanges(primitiveMan.nsRange, NSMakeRange(10, 20)));
    XCTAssertTrue(primitiveMan.pointer == primitiveStruct);
    XCTAssertEqual(primitiveMan.unknownPointer->fieldA, INT32_MAX);
    XCTAssertEqual(primitiveMan.unknownPointer->fieldB, INT64_MAX);
    XCTAssertEqualObjects(primitiveMan.pointerInsideValue, [NSValue valueWithPointer:primitiveStruct]);
    XCTAssertEqual(primitiveMan.unknownStructure.fieldA, 23);
    XCTAssertEqual(primitiveMan.unknownStructure.fieldB, INT64_MAX);

    free(primitiveStruct);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Property injection

- (void)test_injects_required_property_dependencies
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(quest) with:TyphoonInjectionWithReference(@"quest")];
    [_componentFactory registerDefinition:knightDefinition];

    TyphoonDefinition *questDefinition = [[TyphoonDefinition alloc] initWithClass:[CampaignQuest class] key:@"quest"];
    [_componentFactory registerDefinition:questDefinition];

    Knight *knight = [_componentFactory buildInstanceWithDefinition:knightDefinition args:nil];
    XCTAssertNotNil(knight);
    XCTAssertNotNil(knight.quest);
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
        XCTFail(@"Should have thrown exception");
        knight = nil;
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(e.name, @"TyphoonPropertySetterNotFoundException");
    }
}

- (void)test_injects_property_value_as_long
{
    TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(damselsRescued) with:@(12)];
    [_componentFactory registerDefinition:knightDefinition];

    Knight *knight = [_componentFactory componentForKey:@"knight"];
    XCTAssertEqual(knight.damselsRescued, 12);
}

- (void)test_inject_property_value_as_primitives
{
    PrimitiveManStruct *primitiveStruct = malloc(sizeof(PrimitiveManStruct));
    primitiveStruct->fieldA = INT32_MAX;
    primitiveStruct->fieldB = INT64_MAX;
    
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
        primitiveStructOnStack.fieldA = INT32_MAX;
        primitiveStructOnStack.fieldB = INT64_MAX;
        [definition injectProperty:@selector(unknownStructure) with:NSValueFromPrimitive(primitiveStructOnStack)];
    }

    [_componentFactory registerDefinition:definition];
    PrimitiveMan *primitiveMan = [_componentFactory componentForKey:@"primitive"];
    XCTAssertEqual(primitiveMan.intValue, INT_MAX);
    XCTAssertEqual(primitiveMan.unsignedIntValue, UINT_MAX);
    XCTAssertEqual(primitiveMan.shortValue, SHRT_MAX);
    XCTAssertEqual(primitiveMan.unsignedShortValue, USHRT_MAX);
    XCTAssertEqual(primitiveMan.longValue, LONG_MAX);
    XCTAssertEqual(primitiveMan.unsignedLongValue, ULONG_MAX);
    XCTAssertEqual(primitiveMan.longLongValue, LONG_LONG_MAX);
    XCTAssertEqual(primitiveMan.unsignedLongLongValue, ULONG_LONG_MAX);
    XCTAssertEqual(primitiveMan.unsignedCharValue, UCHAR_MAX);
    XCTAssertEqual(primitiveMan.floatValue, FLT_MAX);
    XCTAssertEqual(primitiveMan.doubleValue, DBL_MAX);
    XCTAssertEqual(primitiveMan.boolValue, YES);
    XCTAssertEqual(primitiveMan.integerValue, NSIntegerMax);
    XCTAssertEqual(primitiveMan.unsignedIntegerValue, NSUIntegerMax);
    XCTAssertEqual(primitiveMan.classValue, [self class]);
    XCTAssertEqualObjects(NSStringFromSelector(primitiveMan.selectorValue), NSStringFromSelector(@selector(selectorValue)));
    XCTAssertTrue(NSEqualRanges(primitiveMan.nsRange, NSMakeRange(10, 20)));
    XCTAssertEqual(primitiveMan.unknownPointer->fieldA, INT32_MAX);
    XCTAssertEqual(primitiveMan.unknownPointer->fieldB, INT64_MAX);
    XCTAssertEqual(primitiveMan.pointer, &primitiveStruct);
    XCTAssertEqualObjects(primitiveMan.pointerInsideValue, [NSValue valueWithPointer:&primitiveStruct]);
    XCTAssertEqual(primitiveMan.unknownStructure.fieldA, INT32_MAX);
    XCTAssertEqual(primitiveMan.unknownStructure.fieldB, INT64_MAX);
    XCTAssertTrue(CStringEquals("Hello world", primitiveMan.cString));
    
    primitiveMan.unknownPointer = NULL;
    free(primitiveStruct);
}


//-------------------------------------------------------------------------------------------
#pragma mark - Property injection error handling

- (void)test_raises_exception_if_property_has_no_setter
{
    @try {
        TyphoonDefinition *knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
        [knightDefinition injectProperty:@selector(propertyDoesNotExist) with:@"fooString"];
        [_componentFactory registerDefinition:knightDefinition];

        Knight *knight = [_componentFactory componentForKey:@"knight"];
        NSLog(@"Knight: %@", knight); //Suppress unused warning.
        XCTFail(@"Should have thrown exception");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(e.name, @"TyphoonPropertySetterNotFoundException");
    }

}

/* test_raises_exception_if_property_is_readonly removed, since KVC can set values for read-only properties
 * http://stackoverflow.com/questions/1502708/why-does-a-readonly-property-still-allow-writing-with-kvc  */

@end
