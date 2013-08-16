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
@property(nonatomic) char* cStringProperty;
@property(nonatomic) unsigned char unsignedCharProperty;
@property(nonatomic) NSUInteger unsignedLongLongProperty;
@property(nonatomic) unsigned int unsignedIntProperty;

@end


@implementation TyphoonPrimitiveTypeConverterTests
{
    TyphoonPrimitiveTypeConverter* _typeConverter;
}

- (void)setUp
{
    _typeConverter = [[TyphoonPrimitiveTypeConverter alloc] init];
}

- (void)test_converts_to_bool
{
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
}

- (void)test_converts_to_short
{
    short converted = [_typeConverter convertToShort:@"1245"];
    assertThatShort(converted, equalToShort(1245));
}

- (void)test_converts_to_long
{
    long converted = [_typeConverter convertToLong:@"1245"];
    assertThatLong(converted, equalToLong(1245));
}

- (void)test_converts_to_NSInteger
{
    NSInteger converted = [_typeConverter convertToLongLong:@"1245"];
    assertThatLongLong(converted, equalToLongLong(1245));
}

- (void)test_converts_to_unsigned_char
{
    unsigned char converted = [_typeConverter convertToUnsignedChar:@"65"];
    assertThatUnsignedChar(converted, equalToUnsignedChar(65));
}

- (void)test_converts_to_unsigned_int
{
    unsigned int converted = [_typeConverter convertToUnsignedInt:@"123"];
    assertThatUnsignedInt(converted, equalToUnsignedChar(123));
}

- (void)test_converts_to_unsigned_short
{
    unsigned short converted = [_typeConverter convertToUnsignedShort:@"123"];
    assertThatUnsignedShort(converted, equalToUnsignedShort(123));
}

- (void)test_converts_to_unsigned_long
{
    unsigned long converted = [_typeConverter convertToUnsignedLong:@"123"];
    assertThatUnsignedLong(converted, equalToUnsignedLong(123));
}

- (void)test_converts_to_unsigned_double
{
    double converted = [_typeConverter convertToDouble:@"3.14159628"];
    assertThatDouble(converted, equalToDouble(3.14159628));
}

- (void)test_converts_to_selector
{
    SEL converted = [_typeConverter convertToSelector:@"initWithQuest:"];
    STAssertEquals(converted, @selector(initWithQuest:), nil, nil);
}

- (void)test_converts_to_class
{
    Class converted = [_typeConverter convertToClass:@"NSString"];
    STAssertTrue(converted == [NSString class], nil);
}

- (void)test_converts_to_c_string
{
    const char* converted = [_typeConverter convertToCString:@"the quick brown fox"];
    STAssertTrue(strcmp(converted, [@"the quick brown fox" cStringUsingEncoding:NSUTF8StringEncoding]) == 0, nil);
    NSLog(@"Converted: %s", converted);
}


- (void)test_converts_to_int
{
    int converted = [_typeConverter convertToInt:@"123"];
    assertThatInt(converted, equalToInt(123));

    converted = [_typeConverter convertToInt:@"zzz"];
    assertThatInt(converted, equalToInt(0));
}

- (void)test_converts_to_NSUInteger
{
    NSUInteger converted = [_typeConverter convertToUnsignedLongLong:@"123"];
    assertThatUnsignedLongLong(converted, equalToUnsignedLongLong(123));

    converted = [_typeConverter convertToUnsignedLongLong:@"zzz"];
    assertThatUnsignedLongLong(converted, equalToUnsignedLongLong(0));
}

/* ====================================================================================================================================== */
#pragma mark - Invocations

- (void)test_set_argument_bool
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"boolProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"true" requiredType:descriptor];
    [verify(mockInvocation) setArgument:(void *)YES atIndex:2];
}

- (void)test_set_argument_class
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"classProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"Knight" requiredType:descriptor];
    [verify(mockInvocation) setArgument:(__bridge void*) [NSString class] atIndex:2];
}

- (void)test_set_argument_double
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"doubleProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12.75" requiredType:descriptor];
    double expected = 12.75;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_int
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"intProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12" requiredType:descriptor];
    int expected = 12;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_long
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"longProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"12" requiredType:descriptor];
    long expected = 12;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_selector
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"selectorProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"initWithQuest:" requiredType:descriptor];
    SEL expected = @selector(initWithQuest:);
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_c_string
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"cStringProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"initWithQuest:" requiredType:descriptor];
    char* expected = "the quality";
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_unsigned_char
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"unsignedCharProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"65" requiredType:descriptor];
    char expected = 'A';
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_unsigned_long_long
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"unsignedLongLongProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"36" requiredType:descriptor];
    NSUInteger expected = 36;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}

- (void)test_set_argument_unsigned_int
{
    NSInvocation* mockInvocation = mock([NSInvocation class]);
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"unsignedIntProperty"];
    [_typeConverter setPrimitiveArgumentFor:mockInvocation index:2 textValue:@"36" requiredType:descriptor];
    unsigned int expected = 36;
    [verify(mockInvocation) setArgument:&expected atIndex:2];
}


@end