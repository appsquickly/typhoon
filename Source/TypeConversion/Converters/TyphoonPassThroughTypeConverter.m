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


#import "TyphoonPassThroughTypeConverter.h"


@implementation TyphoonPassThroughTypeConverter

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction

- (id)initWithIsMutable:(BOOL)isMutable
{
    self = [super init];
    if (self) {
        _isMutable = isMutable;
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Protocol Methods

- (id)supportedType
{
    if (_isMutable) {
        return @"NSMutableString";
    }
    else {
        return @"NSString";
    }
}

- (id)convert:(NSString *)stringValue
{
    stringValue = [TyphoonTypeConverterRegistry textWithoutTypeFromTextValue:stringValue];
    
    if (_isMutable) {
        return [NSMutableString stringWithString:stringValue];
    }
    else {
        return [NSString stringWithString:stringValue];
    }
}


@end
