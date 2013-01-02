////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@protocol SpringTypeConverter;
@class SpringTypeDescriptor;
@class SpringPrimitiveTypeConverter;


@interface SpringTypeConverterRegistry : NSObject
{
    SpringPrimitiveTypeConverter* _primitiveTypeConverter;
    NSMutableDictionary* _typeConverters;
}

+ (SpringTypeConverterRegistry*)shared;

- (id <SpringTypeConverter>)converterFor:(id)typeDescriptor;

- (SpringPrimitiveTypeConverter*)primitiveTypeConverter;

- (void)register:(id<SpringTypeConverter>)converter forClassOrProtocol:(id)classOrProtocol;

@end