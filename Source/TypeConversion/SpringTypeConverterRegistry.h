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



#import <Foundation/Foundation.h>

@protocol SpringTypeConverter;
@class SpringTypeDescriptor;


@interface SpringTypeConverterRegistry : NSObject
{
    id<SpringTypeConverter> _primitiveTypeConverter;
    NSMutableDictionary* _typeConverters;
}

+ (SpringTypeConverterRegistry*)shared;

- (id<SpringTypeConverter>)typeConverterFor:(SpringTypeDescriptor*)typeDescriptor;

@end