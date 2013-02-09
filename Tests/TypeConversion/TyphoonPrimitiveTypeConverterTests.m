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
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonIntrospectiveNSObject.h"

@interface TyphoonPrimitiveTypeConverterTests : SenTestCase

@property(nonatomic) BOOL boolProperty;
@property(nonatomic) int intProperty;
@property(nonatomic) NSUInteger nsuIntegerProperty;

@end


@implementation TyphoonPrimitiveTypeConverterTests
{
    TyphoonPrimitiveTypeConverter* _typeConverter;
}

- (void)setUp
{
    _typeConverter = [[TyphoonPrimitiveTypeConverter alloc] init];
}

- (void)test_convertToBool
{
    BOOL converted = (BOOL) [_typeConverter convertToBoolean:@"true"];
    assertThatBool(converted, equalToBool(YES));

    converted = (BOOL) [_typeConverter convertToBoolean:@"yes"];
    assertThatBool(converted, equalToBool(YES));

    converted = (BOOL) [_typeConverter convertToBoolean:@"1"];
    assertThatBool(converted, equalToBool(YES));

    converted = (BOOL) [_typeConverter convertToBoolean:@"no"];
    assertThatBool(converted, equalToBool(NO));

    converted = (BOOL) [_typeConverter convertToBoolean:@"false"];
    assertThatBool(converted, equalToBool(NO));

    converted = (BOOL) [_typeConverter convertToBoolean:@"0"];
    assertThatBool(converted, equalToBool(NO));
}

- (void)test_convertToInt
{
    int converted = (int) [_typeConverter convertToInt:@"123"];
    assertThatInt(converted, equalToInt(123));

    converted = (int) [_typeConverter convertToInt:@"zzz"];
    assertThatInt(converted, equalToInt(0));
}

- (void)test_convertToNSUInteger
{
    NSUInteger converted = (NSUInteger) [_typeConverter convertToUnsignedLongLong:@"123"];
    assertThatUnsignedLongLong(converted, equalToUnsignedLongLong(123));

    converted = (int) [_typeConverter convertToUnsignedLongLong:@"zzz"];
    assertThatUnsignedLongLong(converted, equalToUnsignedLongLong(0));
}

@end