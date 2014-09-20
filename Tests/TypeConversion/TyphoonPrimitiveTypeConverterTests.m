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
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeDescriptor.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "Knight.h"
#import "ClassWithPrimitiveTypesForConversion.h"


#define TYPHOON_TEST_VALUE 65

@interface TyphoonPrimitiveTypeConverterTests : XCTestCase
@end

@implementation TyphoonPrimitiveTypeConverterTests
{
    ClassWithPrimitiveTypesForConversion* _classWithPrimitiveTypesForConversion;
    TyphoonPrimitiveTypeConverter *_typeConverter;
    NSString *_testNumberString;
}

- (void)setUp
{
    _classWithPrimitiveTypesForConversion = [[ClassWithPrimitiveTypesForConversion alloc] init];
    _typeConverter = [[TyphoonPrimitiveTypeConverter alloc] init];
    _testNumberString = [NSString stringWithFormat:@"%@", @(TYPHOON_TEST_VALUE)];
}

- (void)test_converts_to_bool
{
    BOOL converted = [_typeConverter convertToBoolean:@"true"];
    XCTAssertTrue(converted);

    converted = [_typeConverter convertToBoolean:@"yes"];
    XCTAssertTrue(converted);

    converted = [_typeConverter convertToBoolean:@"1"];
    XCTAssertTrue(converted);

    converted = [_typeConverter convertToBoolean:@"no"];
    XCTAssertFalse(converted);

    converted = [_typeConverter convertToBoolean:@"false"];
    XCTAssertFalse(converted);

    converted = [_typeConverter convertToBoolean:@"0"];
    XCTAssertFalse(converted);

    NSNumber *number = [_typeConverter valueFromText:@"true" withType:[TyphoonTypeDescriptor descriptorWithEncodedType:@encode(BOOL)]];
    XCTAssertEqualObjects(number, @(YES));
}

- (void)test_converts_to_short
{
    short converted = [_typeConverter convertToShort:_testNumberString];
    XCTAssertEqual(converted, TYPHOON_TEST_VALUE);

    [self verifyNumberFromTestNumberStringWithType:@encode(short)];
}

- (void)test_converts_to_long
{
    long converted = [_typeConverter convertToLong:_testNumberString];
    XCTAssertEqual(converted, TYPHOON_TEST_VALUE);

    [self verifyNumberFromTestNumberStringWithType:@encode(long)];
}

- (void)test_converts_to_long_long
{
    long long converted = [_typeConverter convertToLongLong:_testNumberString];
    XCTAssertEqual(converted, TYPHOON_TEST_VALUE);

    [self verifyNumberFromTestNumberStringWithType:@encode(long long)];
}

- (void)test_converts_to_unsigned_char
{
    unsigned char converted = [_typeConverter convertToUnsignedChar:@"65"];
    XCTAssertEqual(converted, 65);

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned char)];
}

- (void)test_converts_to_unsigned_int
{
    unsigned int converted = [_typeConverter convertToUnsignedInt:@"123"];
    XCTAssertEqual(converted, 123);

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned int)];
}

- (void)test_converts_to_unsigned_short
{
    unsigned short converted = [_typeConverter convertToUnsignedShort:@"123"];
    XCTAssertEqual(converted, 123);

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned short)];
}

- (void)test_converts_to_unsigned_long
{
    unsigned long converted = [_typeConverter convertToUnsignedLong:@"123"];
    XCTAssertEqual(converted, 123);

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned long)];
}

- (void)test_converts_to_double
{
    double converted = [_typeConverter convertToDouble:@"3.14159628"];
    XCTAssertEqual(converted, 3.14159628);

    [self verifyNumberFromTestNumberStringWithType:@encode(double)];
}

- (void)test_converts_to_selector
{
    SEL converted = [_typeConverter convertToSelector:@"initWithQuest:"];
    XCTAssertEqual(converted, @selector(initWithQuest:));
}

- (void)test_converts_to_class
{
    Class converted = [_typeConverter convertToClass:@"NSString"];
    XCTAssertTrue(converted == [NSString class]);
}

- (void)test_converts_to_c_string
{
    const char *converted = [_typeConverter convertToCString:@"the quick brown fox"];
    XCTAssertTrue(strcmp(converted, [@"the quick brown fox" cStringUsingEncoding:NSUTF8StringEncoding]) == 0);
}


- (void)test_converts_to_int
{
    int converted = [_typeConverter convertToInt:@"123"];
    XCTAssertEqual(converted, 123);

    converted = [_typeConverter convertToInt:@"zzz"];
    XCTAssertEqual(converted, 0);
}

- (void)test_converts_to_NSUInteger
{
    NSUInteger converted = (NSUInteger)[_typeConverter convertToUnsignedLongLong:@"123"];
    XCTAssertEqual(converted, 123);

    converted = (NSUInteger)[_typeConverter convertToUnsignedLongLong:@"zzz"];
    XCTAssertEqual(converted, 0);
}

#pragma mark - valueForText:withType:
- (void)test_pointer_type
{
    NSString *typeCode = [NSString stringWithCString:@encode(void *) encoding:NSUTF8StringEncoding];
    TyphoonTypeDescriptor *pointerType = [[TyphoonTypeDescriptor alloc] initWithTypeCode:typeCode];

    id valueOrNumber = [_typeConverter valueFromText:@"123456" withType:pointerType];

    void *pointer = [valueOrNumber pointerValue];
    XCTAssertEqual(pointer, (void *) 123456);
}

- (void)test_unknown_pointer_type
{
    TyphoonTypeDescriptor *unknownPointerType = [[TyphoonTypeDescriptor alloc] initWithTypeCode:@"^?"];

    id valueOrNumber = [_typeConverter valueFromText:@"123456" withType:unknownPointerType];

    void *pointer = [valueOrNumber pointerValue];
    XCTAssertEqual(pointer, (void *) 123456);
}

- (void)test_unknown_type
{
    TyphoonTypeDescriptor *unknownType = [[TyphoonTypeDescriptor alloc] initWithTypeCode:@"?"];

    @try {
        [_typeConverter valueFromText:@"123456" withType:unknownType];
        XCTFail(@"Attempting to create a value from a non-pointer of unknown type should raise an exception.");
    }
    @catch (NSException *exception) {
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Invocations

//- (void)test_set_argument_bool
//{
//    NSInvocation *mockInvocation = MKTMock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"boolProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"true" requiredType:descriptor];
//    [MKTVerify(mockInvocation) setArgument:YES atIndex:2];
//}
//
//- (void)test_set_argument_class
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"classProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"Knight" requiredType:descriptor];
//    [MKTVerify(mockInvocation) setArgument:(__bridge void *) [NSString class] atIndex:2];
//}
//
//- (void)test_set_argument_double
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"doubleProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12.75" requiredType:descriptor];
//    double expected = 12.75;
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}
//
//- (void)test_set_argument_int
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"intProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12" requiredType:descriptor];
//    int expected = 12;
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}
//
//- (void)test_set_argument_long
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"longProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12" requiredType:descriptor];
//    long expected = 12;
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}
//
//- (void)test_set_argument_selector
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"selectorProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"initWithQuest:" requiredType:descriptor];
//    SEL expected = @selector(initWithQuest:);
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}
//
//- (void)test_set_argument_c_string
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"cStringProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"initWithQuest:" requiredType:descriptor];
//    char *expected = "the quality";
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}
//
//- (void)test_set_argument_unsigned_char
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"unsignedCharProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"65" requiredType:descriptor];
//    char expected = 'A';
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}
//
//- (void)test_set_argument_unsigned_long_long
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"unsignedLongLongProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"36" requiredType:descriptor];
//    NSUInteger expected = 36;
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}
//
//- (void)test_set_argument_unsigned_int
//{
//    NSInvocation *mockInvocation = mock([NSInvocation class]);
//    TyphoonTypeDescriptor *descriptor = [_classWithPrimitiveTypesForConversion typhoon_typeForPropertyWithName:@"unsignedIntProperty"];
//    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"36" requiredType:descriptor];
//    unsigned int expected = 36;
//    [MKTVerify(mockInvocation) setArgument:&expected atIndex:2];
//}

#pragma mark - Helpers

- (void)verifyNumberFromTestNumberStringWithType:(char *)type
{
    NSNumber *number = [_typeConverter valueFromText:_testNumberString withType:[TyphoonTypeDescriptor descriptorWithEncodedType:type]];
    XCTAssertEqualObjects(number, @(TYPHOON_TEST_VALUE));
}


@end