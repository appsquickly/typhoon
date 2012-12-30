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



#import <objc/runtime.h>
#import "SpringTypeConverterRegistry.h"
#import "SpringTypeConverter.h"
#import "SpringTypeDescriptor.h"
#import "SpringPrimitiveTypeConverter.h"
#import "SpringPassThroughTypeConverter.h"
#import "SpringNSURLTypeConverter.h"


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

        [self register:[[SpringPassThroughTypeConverter alloc] initWithIsMutable:NO] forClassOrProtocol:[NSString class]];
        [self register:[[SpringPassThroughTypeConverter alloc] initWithIsMutable:YES] forClassOrProtocol:[NSMutableString class]];
        [self register:[[SpringNSURLTypeConverter alloc] init] forClassOrProtocol:[NSURL class]];
    }
    return self;
}


/* ========================================================== Interface Methods ========================================================= */
- (id <SpringTypeConverter>)converterFor:(SpringTypeDescriptor*)typeDescriptor
{

    id <SpringTypeConverter> converter = [_typeConverters objectForKey:[typeDescriptor classOrProtocol]];
    if (!converter)
    {
        [NSException raise:NSInvalidArgumentException format:@"No type converter registered for type: '%@'.",
                                                             [typeDescriptor classOrProtocol]];

    }
    return converter;
}

- (SpringPrimitiveTypeConverter*)primitiveTypeConverter
{
    return _primitiveTypeConverter;
}

- (void)register:(id <SpringTypeConverter>)converter forClassOrProtocol:(id)classOrProtocol;
{
    if (!([_typeConverters objectForKey:classOrProtocol]))
    {
        [_typeConverters setObject:converter forKey:(id <NSCopying>) classOrProtocol];
    }
    else
    {
        BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
        NSString* name = isClass ? NSStringFromClass(classOrProtocol) : NSStringFromProtocol(classOrProtocol);
        [NSException raise:NSInvalidArgumentException format:@"Converter for '%@' already registered.", name];
    }
}


@end