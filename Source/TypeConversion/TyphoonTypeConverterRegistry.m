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


#import <objc/runtime.h>
#import "TyphoonTypeConverterRegistry.h"
#import "TyphonTypeConverter.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonPassThroughTypeConverter.h"
#import "TyphoonNSURLTypeConverter.h"


@implementation TyphoonTypeConverterRegistry

/* =========================================================== Class Methods ============================================================ */
+ (TyphoonTypeConverterRegistry*)shared
{
    static dispatch_once_t onceToken;
    static TyphoonTypeConverterRegistry* instance;

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
        _primitiveTypeConverter = [[TyphoonPrimitiveTypeConverter alloc] init];

        [self register:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:NO] forClassOrProtocol:[NSString class]];
        [self register:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:YES] forClassOrProtocol:[NSMutableString class]];
        [self register:[[TyphoonNSURLTypeConverter alloc] init] forClassOrProtocol:[NSURL class]];
    }
    return self;
}


/* ========================================================== Interface Methods ========================================================= */
- (id <TyphonTypeConverter>)converterFor:(TyphoonTypeDescriptor*)typeDescriptor
{

    id <TyphonTypeConverter> converter = [_typeConverters objectForKey:[typeDescriptor classOrProtocol]];
    if (!converter)
    {
        [NSException raise:NSInvalidArgumentException format:@"No type converter registered for type: '%@'.",
                                                             [typeDescriptor classOrProtocol]];

    }
    return converter;
}

- (TyphoonPrimitiveTypeConverter*)primitiveTypeConverter
{
    return _primitiveTypeConverter;
}

- (void)register:(id <TyphonTypeConverter>)converter forClassOrProtocol:(id)classOrProtocol;
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