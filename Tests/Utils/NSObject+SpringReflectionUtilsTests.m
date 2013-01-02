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
#import "SpringTypeDescriptor.h"
#import "Knight.h"
#import "NSObject+SpringReflectionUtils.h"
#import "SpringLogTemplate.h"

typedef struct
{
    int foo;
    char bar[255];
} SomeStructType;

@interface NSObject_SpringReflectionUtilsTests : SenTestCase

@property(nonatomic, readonly) char charProperty;
@property(nonatomic, readonly) int intProperty;
@property(nonatomic, readonly) short shortProperty;
@property(nonatomic, readonly) long longProperty;
@property(nonatomic, readonly) NSUInteger* pointerToLongLongProperty;
@property(nonatomic, readonly) SomeStructType structProperty;

@end


@implementation NSObject_SpringReflectionUtilsTests

- (void)test_typeForPropertyWithName_char
{
    SpringTypeDescriptor* descriptor = [self typeForPropertyWithName:@"charProperty"];
    assertThatBool(descriptor.isPrimitive, equalToBool(YES));
    assertThatInt(descriptor.primitiveType, equalToInt(SpringPrimitiveTypeChar));
}

- (void)test_typeForPropertyWithName_int
{
    SpringTypeDescriptor* descriptor = [self typeForPropertyWithName:@"intProperty"];
    assertThatBool(descriptor.isPrimitive, equalToBool(YES));
    assertThatBool(descriptor.isPointer, equalToBool(NO));
    assertThatInt(descriptor.primitiveType, equalToInt(SpringPrimitiveTypeInt));
}

- (void)test_typeForPropertyWithName_short
{
    SpringTypeDescriptor* descriptor = [self typeForPropertyWithName:@"shortProperty"];
    assertThatBool(descriptor.isPrimitive, equalToBool(YES));
    assertThatBool(descriptor.isPointer, equalToBool(NO));
    assertThatInt(descriptor.primitiveType, equalToInt(SpringPrimitiveTypeShort));
}

- (void)test_typeForPropertyWithName_long
{
    SpringTypeDescriptor* descriptor = [self typeForPropertyWithName:@"longProperty"];
    assertThatBool(descriptor.isPrimitive, equalToBool(YES));
    assertThatBool(descriptor.isPointer, equalToBool(NO));
    assertThatInt(descriptor.primitiveType, equalToInt(SpringPrimitiveTypeLongLong));
}

- (void)test_typeForPropertyWithName_pointerToLongLong
{
    SpringTypeDescriptor* descriptor = [self typeForPropertyWithName:@"pointerToLongLongProperty"];
    assertThatBool(descriptor.isPrimitive, equalToBool(YES));
    assertThatBool(descriptor.isPointer, equalToBool(YES));
    assertThatInt(descriptor.primitiveType, equalToInt(SpringPrimitiveTypeUnsignedLongLong));
}

- (void)test_typeForPropertyWithName_struct
{
    SpringTypeDescriptor* descriptor = [self typeForPropertyWithName:@"structProperty"];
    assertThatBool(descriptor.isPrimitive, equalToBool(YES));
    assertThatBool(descriptor.isPointer, equalToBool(NO));
    assertThatBool(descriptor.isStructure, equalToBool(YES));
    assertThat(descriptor.structureTypeName, equalTo(@"?=i[255c]"));
}

- (void)test_parameterNamesForSelector_init_method
{
    NSArray* parameterNames = [self parameterNamesForSelector:@selector(initWithNibName:bundle:)];
    SpringDebug(@"Parameter names: %@", parameterNames);
    assertThat(parameterNames, hasCountOf(2));
    assertThat([parameterNames objectAtIndex:0], equalTo(@"nibName"));
    assertThat([parameterNames objectAtIndex:1], equalTo(@"bundle"));
}

- (void)test_parameterNamesForSelector_factory_method
{
    NSArray* parameterNames = [self parameterNamesForSelector:@selector(URLWithString:)];
    SpringDebug(@"Parameter names: %@", parameterNames);
    assertThat(parameterNames, hasCountOf(1));
    assertThat([parameterNames objectAtIndex:0], equalTo(@"string"));
}

- (void)test_typeCodesForSelectorWithName
{
    Knight* knight = [[Knight alloc] initWithQuest:nil damselsRescued:0];
    NSArray* typeCodes = [knight typeCodesForSelector:@selector(initWithQuest:damselsRescued:)];

    SpringDebug(@"Here's the typeCodes: %@", typeCodes);
    assertThat([typeCodes objectAtIndex:0], equalTo(@"@"));
    assertThat([typeCodes objectAtIndex:1], equalTo(@"Q"));

//    SpringTypeDescriptor* typeDescriptor = [SpringTypeDescriptor descriptorWithClassOrProtocol:@protocol(NSObject)];
//    assertThatBool(typeDescriptor.isPrimitive, equalToBool(NO));
//    assertThat([typeDescriptor classOrProtocol], notNilValue());
//    LogDebug(@"The type: %@", NSStringFromProtocol(typeDescriptor.classOrProtocol));


    SpringTypeDescriptor* typeDescriptor = [SpringTypeDescriptor descriptorWithTypeCode:[typeCodes objectAtIndex:1]];
    assertThatBool(typeDescriptor.isPrimitive, equalToBool(YES));
    assertThatInt(typeDescriptor.primitiveType, equalToInt(SpringPrimitiveTypeUnsignedLongLong));

}


@end