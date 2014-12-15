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

#import "PrimitiveMan.h"


@implementation PrimitiveMan
{

}

- (id)initWithIntValue:(int)intValue unsignedIntValue:(unsigned int)unsignedIntValue shortValue:(short)shortValue
    unsignedShortValue:(unsigned short)unsignedShortValue longValue:(long)longValue unsignedLongValue:(unsigned long)unsignedLongValue
    longLongValue:(long long)longLongValue unsignedLongLongValue:(unsigned long long)unsignedLongLongValue
    unsignedCharValue:(unsigned char)unsignedCharValue floatValue:(float)floatValue doubleValue:(double)doubleValue
    boolValue:(BOOL)boolValue integerValue:(NSInteger)integerValue unsignedIntegerValue:(NSUInteger)unsignedIntegerValue
    classValue:(Class)classValue selectorValue:(SEL)selectorValue cstring:(char *)cString nsRange:(NSRange)nsRange
    pointerValue:(void *)pointer unknownPointer:(PrimitiveManStruct *)unknownPointer pointerInsideValue:(NSValue *)pointerInsideValue unknownStructure:(PrimitiveManStruct)unknownStructure
{
    self = [super init];
    if (self) {
        _intValue = intValue;
        _unsignedIntValue = unsignedIntValue;
        _shortValue = shortValue;
        _unsignedShortValue = unsignedShortValue;
        _longValue = longValue;
        _unsignedLongValue = unsignedLongValue;
        _longLongValue = longLongValue;
        _unsignedLongLongValue = unsignedLongLongValue;
        _unsignedCharValue = unsignedCharValue;
        _floatValue = floatValue;
        _doubleValue = doubleValue;
        _boolValue = boolValue;
        _integerValue = integerValue;
        _unsignedIntegerValue = unsignedIntegerValue;
        _classValue = classValue;
        _selectorValue = selectorValue;
        _cString = cString;
        _nsRange = nsRange;
        _pointer = pointer;
        _unknownPointer = unknownPointer;
        _pointerInsideValue = pointerInsideValue;
        _unknownStructure = unknownStructure;
    }
    return self;
}


@end