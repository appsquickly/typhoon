////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import "TyphoonTypeDescriptor.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "Quest.h"
#import "Knight.h"

typedef struct
{
    int foo;
    char bar[255];
} SomeStructType;

@interface TyphoonTypeDescriptorTests : XCTestCase

@property BOOL aBoolProperty;
@property NSURL *anNSURLProperty;
@property id <Quest> aQuestProperty;
@property NSObject <Quest> *anObjectQuestProperty;

@property(nonatomic, readonly) char charProperty;
@property(nonatomic, readonly) int intProperty;
@property(nonatomic, readonly) short shortProperty;
@property(nonatomic, readonly) long longProperty;
@property(nonatomic, readonly) NSUInteger *pointerToLongLongProperty;
@property(nonatomic, readonly) SomeStructType structProperty;

@end

@implementation TyphoonTypeDescriptorTests

- (void)test_type_description_primitive
{
    // Depending on the platform, bools are encoded either as chars or as bool
    // both are 1 byte, and with 1 byte padding.
    // iOS 64 bits is the one needing this "template", so we don't hardcode the
    // expected description below.
    TyphoonTypeDescriptor *boolDescriptor =
        [TyphoonTypeDescriptor descriptorWithTypeCode:[NSString stringWithCString:@encode(BOOL) encoding:NSASCIIStringEncoding]];

    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"aBoolProperty"];
    XCTAssertTrue([descriptor isPrimitive]);
    XCTAssertNil([descriptor typeBeingDescribed]);
    XCTAssertNil([descriptor protocol]);
    XCTAssertFalse([descriptor isArray]);
    XCTAssertEqual([descriptor arrayLength], 0);
    XCTAssertEqual(descriptor.primitiveType, boolDescriptor.primitiveType);

    NSString *description = [descriptor description];
    XCTAssertEqualObjects(description, [boolDescriptor description]);
}

- (void)test_type_description_class
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"anNSURLProperty"];
    XCTAssertFalse([descriptor isPrimitive]);
    XCTAssertEqual([descriptor typeBeingDescribed], [NSURL class]);
    XCTAssertNil([descriptor protocol]);

    NSString *description = [descriptor description];
    XCTAssertEqualObjects(description, @"Type descriptor: NSURL");
}

- (void)test_type_description_protocol
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"aQuestProperty"];
    XCTAssertFalse([descriptor isPrimitive]);
    XCTAssertNil([descriptor typeBeingDescribed]);
    XCTAssertEqual([descriptor protocol], @protocol(Quest));

    NSString *description = [descriptor description];
    XCTAssertEqualObjects(description, @"Type descriptor: id<Quest>");
}

- (void)test_type_description_class_and_protocol
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"anObjectQuestProperty"];
    XCTAssertFalse([descriptor isPrimitive]);
    XCTAssertEqual([descriptor protocol], @protocol(Quest));
    XCTAssertEqual([descriptor typeBeingDescribed], [NSObject class]);

    NSString *description = [descriptor description];
    XCTAssertEqualObjects(description, @"Type descriptor: NSObject<Quest>");
}


- (void)test_typeForPropertyWithName_char
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"charProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertEqual(descriptor.primitiveType, TyphoonPrimitiveTypeChar);
}

- (void)test_typeForPropertyWithName_int
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"intProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
    XCTAssertEqual(descriptor.primitiveType, TyphoonPrimitiveTypeInt);
}

- (void)test_typeForPropertyWithName_short
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"shortProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
    XCTAssertEqual(descriptor.primitiveType, TyphoonPrimitiveTypeShort);
}

- (void)test_typeForPropertyWithName_long
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"longProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
}

- (void)test_typeForPropertyWithName_pointerToLongLong
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"pointerToLongLongProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertTrue(descriptor.isPointer);
}

- (void)test_typeForPropertyWithName_struct
{
    TyphoonTypeDescriptor *descriptor = [self typhoon_typeForPropertyWithName:@"structProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
    XCTAssertTrue(descriptor.isStructure);
    XCTAssertEqualObjects(descriptor.structureTypeName, @"?=i[255c]");
}

- (void)test_parameterNamesForSelector_init_method
{
    NSArray *parameterNames = [self typhoon_parameterNamesForSelector:@selector(initWithNibName:bundle:)];
    XCTAssertTrue([parameterNames count] == 2);
    XCTAssertEqualObjects([parameterNames objectAtIndex:0], @"nibName");
    XCTAssertEqualObjects([parameterNames objectAtIndex:1], @"bundle");
}

- (void)test_parameterNamesForSelector_factory_method
{
    NSArray *parameterNames = [self typhoon_parameterNamesForSelector:@selector(URLWithString:)];
    XCTAssertTrue([parameterNames count] == 1);
    XCTAssertEqualObjects([parameterNames objectAtIndex:0], @"string");
}

- (void)test_parameterNamesForSelector_no_parameters_method
{
    NSArray *parameterNames = [self typhoon_parameterNamesForSelector:@selector(init)];
    XCTAssertTrue([parameterNames count] == 0);
}

- (void)test_typeCodesForSelectorWithName
{
    Knight *knight = [[Knight alloc] initWithQuest:nil damselsRescued:0];
    NSArray *typeCodes = [knight typhoon_typeCodesForSelector:@selector(initWithQuest:damselsRescued:)];

    NSString *questTypeCode = [typeCodes objectAtIndex:0];
    XCTAssertEqualObjects(questTypeCode, @"@"); // an object

    NSString *damselsRescuedTypeCode = [typeCodes objectAtIndex:1];
    TyphoonTypeDescriptor *typeDescriptor = [TyphoonTypeDescriptor descriptorWithTypeCode:damselsRescuedTypeCode];
    XCTAssertTrue(typeDescriptor.isPrimitive); // a primitive. The parameter is NSUInteger, whose type code depends on the architecture.
}

@end