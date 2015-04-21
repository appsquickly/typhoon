////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
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

    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"aBoolProperty"];
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
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"anNSURLProperty"];
    XCTAssertFalse([descriptor isPrimitive]);
    XCTAssertEqual([descriptor typeBeingDescribed], [NSURL class]);
    XCTAssertNil([descriptor protocol]);

    NSString *description = [descriptor description];
    XCTAssertEqualObjects(description, @"Type descriptor: NSURL");
}

- (void)test_type_description_protocol
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"aQuestProperty"];
    XCTAssertFalse([descriptor isPrimitive]);
    XCTAssertNil([descriptor typeBeingDescribed]);
    XCTAssertEqual([descriptor protocol], @protocol(Quest));

    NSString *description = [descriptor description];
    XCTAssertEqualObjects(description, @"Type descriptor: id<Quest>");
}

- (void)test_type_description_class_and_protocol
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"anObjectQuestProperty"];
    XCTAssertFalse([descriptor isPrimitive]);
    XCTAssertEqual([descriptor protocol], @protocol(Quest));
    XCTAssertEqual([descriptor typeBeingDescribed], [NSObject class]);

    NSString *description = [descriptor description];
    XCTAssertEqualObjects(description, @"Type descriptor: NSObject<Quest>");
}


- (void)test_typeForPropertyWithName_char
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"charProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertEqual(descriptor.primitiveType, TyphoonPrimitiveTypeChar);
}

- (void)test_typeForPropertyWithName_int
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"intProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
    XCTAssertEqual(descriptor.primitiveType, TyphoonPrimitiveTypeInt);
}

- (void)test_typeForPropertyWithName_short
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"shortProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
    XCTAssertEqual(descriptor.primitiveType, TyphoonPrimitiveTypeShort);
}

- (void)test_typeForPropertyWithName_long
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"longProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
}

- (void)test_typeForPropertyWithName_pointerToLongLong
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"pointerToLongLongProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertTrue(descriptor.isPointer);
}

- (void)test_typeForPropertyWithName_struct
{
    TyphoonTypeDescriptor *descriptor = [self typhoonTypeForPropertyNamed:@"structProperty"];
    XCTAssertTrue(descriptor.isPrimitive);
    XCTAssertFalse(descriptor.isPointer);
    XCTAssertTrue(descriptor.isStructure);
    XCTAssertEqualObjects(descriptor.structureTypeName, @"?=i[255c]");
}


@end