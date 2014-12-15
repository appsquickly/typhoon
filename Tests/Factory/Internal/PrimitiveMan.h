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

#import <Foundation/Foundation.h>


typedef struct
{
    SInt32 fieldA;
    SInt64 fieldB;
} PrimitiveManStruct;

@interface PrimitiveMan : NSObject

- (id)initWithIntValue:(int)intValue unsignedIntValue:(unsigned int)unsignedIntValue shortValue:(short)shortValue
    unsignedShortValue:(unsigned short)unsignedShortValue longValue:(long)longValue unsignedLongValue:(unsigned long)unsignedLongValue
    longLongValue:(long long)longLongValue unsignedLongLongValue:(unsigned long long)unsignedLongLongValue
    unsignedCharValue:(unsigned char)unsignedCharValue floatValue:(float)floatValue doubleValue:(double)doubleValue
    boolValue:(BOOL)boolValue integerValue:(NSInteger)integerValue unsignedIntegerValue:(NSUInteger)unsignedIntegerValue
    classValue:(Class)classValue selectorValue:(SEL)selectorValue cstring:(char *)cString nsRange:(NSRange)nsRange
          pointerValue:(void *)pointer unknownPointer:(PrimitiveManStruct *)unknownPointer pointerInsideValue:(NSValue *)pointerInsideValue unknownStructure:(PrimitiveManStruct)unknownStructure;


@property(nonatomic, assign) int intValue;
@property(nonatomic, assign) short shortValue;
@property(nonatomic, assign) long longValue;
@property(nonatomic, assign) long long longLongValue;
@property(nonatomic, assign) unsigned char unsignedCharValue;
@property(nonatomic, assign) unsigned int unsignedIntValue;
@property(nonatomic, assign) unsigned short unsignedShortValue;
@property(nonatomic, assign) unsigned long unsignedLongValue;
@property(nonatomic, assign) unsigned long long unsignedLongLongValue;
@property(nonatomic, assign) float floatValue;
@property(nonatomic, assign) double doubleValue;
@property(nonatomic, assign) BOOL boolValue;
@property(nonatomic, assign) Class classValue;
@property(nonatomic, assign) SEL selectorValue;
@property(nonatomic, assign) char *cString;
@property(nonatomic, assign) NSInteger integerValue;
@property(nonatomic, assign) NSUInteger unsignedIntegerValue;
@property(nonatomic, assign) NSRange nsRange;
@property(nonatomic, assign) void *pointer;
@property(nonatomic, assign, setter = unknownPointerSetter:) PrimitiveManStruct *unknownPointer;
@property(nonatomic, assign) NSValue *pointerInsideValue;
@property(nonatomic, assign) PrimitiveManStruct unknownStructure;


@end