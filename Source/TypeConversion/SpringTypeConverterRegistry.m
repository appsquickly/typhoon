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



#import "SpringTypeConverterRegistry.h"
#import "SpringTypeConverter.h"
#import "SpringTypeDescriptor.h"
#import "SpringPrimitiveTypeConverter.h"


@implementation SpringTypeConverterRegistry

/* =========================================================== Class Methods ============================================================ */
+ (SpringTypeConverterRegistry*)shared
{
    static dispatch_once_t onceToken;
    static SpringTypeConverterRegistry* instance;

    dispatch_once(&onceToken, ^
{
    instance = [[[self class] alloc] init];
});
    return instance;
}

/* ============================================================ Initializers ============================================================ */
- (id)init
{
    self = [super init];
    if (self)
    {
        _typeConverters = [[NSMutableDictionary alloc] init];
        _primitiveTypeConverter = [[SpringPrimitiveTypeConverter alloc] init];
    }
    return self;
}


/* ========================================================== Interface Methods ========================================================= */
- (id <SpringTypeConverter>)converterFor:(SpringTypeDescriptor*)typeDescriptor
{
    if (typeDescriptor.isPrimitive)
    {
        return _primitiveTypeConverter;
    }
    else
    {
        id <SpringTypeConverter> converter = [_typeConverters objectForKey:[typeDescriptor classOrProtocol]];
        if (converter)
        {
            return converter;
        }
    }
    [NSException raise:NSInvalidArgumentException format:@"No type converter registered for type: '%@'.", [typeDescriptor classOrProtocol]];
}


@end