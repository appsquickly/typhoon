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
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeDescriptor.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "Knight.h"

@interface TyphoonPrimitiveTypeConverterTests : SenTestCase

@property(nonatomic) BOOL boolProperty;
@property(nonatomic) int intProperty;
@property(nonatomic) NSUInteger nsuIntegerProperty;
@property(nonatomic) Class classProperty;
@property(nonatomic) double doubleProperty;
@property(nonatomic) long longProperty;
@property(nonatomic) SEL selectorProperty;
@property(nonatomic) char *cStringProperty;
@property(nonatomic) unsigned char unsignedCharProperty;
@property(nonatomic) NSUInteger unsignedLongLongProperty;
@property(nonatomic) unsigned int unsignedIntProperty;

@end

#define TYPHOON_TEST_VALUE 65

@implementation TyphoonPrimitiveTypeConverterTests
{
    TyphoonPrimitiveTypeConverter *_typeConverter;
    NSString *_testNumberString;
}

- (void)setUp {
    _typeConverter = [[TyphoonPrimitiveTypeConverter alloc] init];
    _testNumberString = [NSString stringWithFormat:@"%@", @(TYPHOON_TEST_VALUE)];
}

- (void)test_converts_to_bool {
    BOOL converted = [_typeConverter convertToBoolean:@"true"];
    assertThatBool(converted, equalToBool(YES));

    converted = [_typeConverter convertToBoolean:@"yes"];
    assertThatBool(converted, equalToBool(YES));

    converted = [_typeConverter convertToBoolean:@"1"];
    assertThatBool(converted, equalToBool(YES));

    converted = [_typeConverter convertToBoolean:@"no"];
    assertThatBool(converted, equalToBool(NO));

    converted = [_typeConverter convertToBoolean:@"false"];
    assertThatBool(converted, equalToBool(NO));

    converted = [_typeConverter convertToBoolean:@"0"];
    assertThatBool(converted, equalToBool(NO));

    NSNumber *number = [_typeConverter valueFromText:@"true" withType:[TyphoonTypeDescriptor descriptorWithEncodedType:@encode(BOOL)]];
    assertThat(number, equalTo(@YES));
}

- (void)test_converts_to_short {
    short converted = [_typeConverter convertToShort:_testNumberString];
    assertThatShort(converted, equalToShort(TYPHOON_TEST_VALUE));

    [self verifyNumberFromTestNumberStringWithType:@encode(short)];
}

- (void)test_converts_to_long {
    long converted = [_typeConverter convertToLong:_testNumberString];
    assertThatLong(converted, equalToLong(TYPHOON_TEST_VALUE));

    [self verifyNumberFromTestNumberStringWithType:@encode(long)];
}

- (void)test_converts_to_long_long {
    long long converted = [_typeConverter convertToLongLong:_testNumberString];
    assertThatLongLong(converted, equalToLongLong(TYPHOON_TEST_VALUE));

    [self verifyNumberFromTestNumberStringWithType:@encode(long long)];
}

- (void)test_converts_to_unsigned_char {
    unsigned char converted = [_typeConverter convertToUnsignedChar:@"65"];
    assertThatUnsignedChar(converted, equalToUnsignedChar(65));

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned char)];
}

- (void)test_converts_to_unsigned_int {
    unsigned int converted = [_typeConverter convertToUnsignedInt:@"123"];
    assertThatUnsignedInt(converted, equalToUnsignedChar(123));

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned int)];
}

- (void)test_converts_to_unsigned_short {
    unsigned short converted = [_typeConverter convertToUnsignedShort:@"123"];
    assertThatUnsignedShort(converted, equalToUnsignedShort(123));

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned short)];
}

- (void)test_converts_to_unsigned_long {
    unsigned long converted = [_typeConverter convertToUnsignedLong:@"123"];
    assertThatUnsignedLong(converted, equalToUnsignedLong(123));

    [self verifyNumberFromTestNumberStringWithType:@encode(unsigned long)];
}

- (void)test_converts_to_double {
    double converted = [_typeConverter convertToDouble:@"3.14159628"];
    assertThatDouble(converted, equalToDouble(3.14159628));

    [self verifyNumberFromTestNumberStringWithType:@encode(double)];
}

- (void)test_converts_to_selector {
    SEL converted = [_typeConverter convertToSelector:@"initWithQuest:"];
    STAssertEquals(converted, @selector(initWithQuest:), nil, nil);
}

- (void)test_converts_to_class {
    Class converted = [_typeConverter convertToClass:@"NSString"];
    STAssertTrue(converted == [NSString class], nil);
}

- (void)test_converts_to_c_string {
    const char *converted = [_typeConverter convertToCString:@"the quick brown fox"];
    STAssertTrue(strcmp(converted, [@"the quick brown fox" cStringUsingEncoding:NSUTF8StringEncoding]) == 0, nil);
}


- (void)test_converts_to_int {
    int converted = [_typeConverter convertToInt:@"123"];
    assertThatInt(converted, equalToInt(123));

    converted = [_typeConverter convertToInt:@"zzz"];
    assertThatInt(converted, equalToInt(0));
}

- (void)test_converts_to_NSUInteger {
    NSUInteger converted = [_typeConverter convertToUnsignedLongLong:@"123"];
    assertThatUnsignedLongLong(converted, equalToUnsignedLongLong(123));

    converted = [_typeConverter convertToUnsignedLongLong:@"zzz"];
    assertThatUnsignedLongLong(converted, equalToUnsignedLongLong(0));
}

#pragma mark - valueForText:withType:
- (void)test_pointer_type {
    NSString *typeCode = [NSString stringWithCString:@encode(void *) encoding:NSUTF8StringEncoding];
    TyphoonTypeDescriptor *pointerType = [[TyphoonTypeDescriptor alloc] initWithTypeCode:typeCode];

    id valueOrNumber = [_typeConverter valueFromText:@"123456" withType:pointerType];

    void *pointer = [valueOrNumber pointerValue];
    STAssertEquals(pointer, (void *) 123456, nil);
}

- (void)test_unknown_pointer_type {
    TyphoonTypeDescriptor *unknownPointerType = [[TyphoonTypeDescriptor alloc] initWithTypeCode:@"^?"];

    id valueOrNumber = [_typeConverter valueFromText:@"123456" withType:unknownPointerType];

    void *pointer = [valueOrNumber pointerValue];
    STAssertEquals(pointer, (void *) 123456, nil);
}

- (void)test_unknown_type {
    TyphoonTypeDescriptor *unknownType = [[TyphoonTypeDescriptor alloc] initWithTypeCode:@"?"];

    @try {
        [_typeConverter valueFromText:@"123456" withType:unknownType];
        STFail(@"Attempting to create a value from a non-pointer of unknown type should raise an exception.");
    }
    @catch (NSException *exception) {
    }
}

/* ====================================================================================================================================== */
#pragma mark - Invocations

- (void)test_set_argument_bool {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"boolProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"true" requiredType:descriptor];
    [verify(mockInvocation) setArgument:(void *) YES atIndex:2];
}

- (void)test_set_argument_class {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"classProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"Knight" requiredType:descriptor];
    [verify(mockInvocation) setArgument:(__bridge void *) [NSString class] atIndex:2];
}

- (void)test_set_argument_double {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"doubleProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12.75" requiredType:descriptor];
    double expected = 12.75;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_int {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"intProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12" requiredType:descriptor];
    int expected = 12;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_long {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"longProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12" requiredType:descriptor];
    long expected = 12;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_selector {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"selectorProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"initWithQuest:" requiredType:descriptor];
    SEL expected = @selector(initWithQuest:);
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_c_string {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"cStringProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"initWithQuest:" requiredType:descriptor];
    char *expected = "the quality";
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_unsigned_char {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"unsignedCharProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"65" requiredType:descriptor];
    char expected = 'A';
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_unsigned_long_long {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"unsignedLongLongProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"36" requiredType:descriptor];
    NSUInteger expected = 36;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_unsigned_int {
    NSInvocation *mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor *descriptor = [self typeForPropertyWithName:@"unsignedIntProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"36" requiredType:descriptor];
    unsigned int expected = 36;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

#pragma mark - Helpers
- (void)verifyNumberFromTestNumberStringWithType:(char *)type {
    NSNumber *number = [self valueFromTestNumberStringWithType:type];
    assertThat(number, equalTo(@(TYPHOON_TEST_VALUE)));
}

- (id)valueFromTestNumberStringWithType:(char *)type {
    return [_typeConverter valueFromText:_testNumberString withType:[TyphoonTypeDescriptor descriptorWithEncodedType:type]];
}


@end