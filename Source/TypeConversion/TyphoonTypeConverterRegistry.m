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


#import <objc/runtime.h>
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonPassThroughTypeConverter.h"
#import "TyphoonNSURLTypeConverter.h"

#if TARGET_OS_IPHONE

#import "TyphoonUIColorTypeConverter.h"
#import "TyphoonBundledImageTypeConverter.h"

#endif


@implementation TyphoonTypeConverterRegistry

/* ====================================================================================================================================== */
#pragma mark - Class Methods

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

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self)
    {
        _typeConverters = [[NSMutableDictionary alloc] init];
        _primitiveTypeConverter = [[TyphoonPrimitiveTypeConverter alloc] init];

        [self registerSharedConverters];
        [self registerPlatformConverters];


    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (id <TyphoonTypeConverter>)converterFor:(TyphoonTypeDescriptor*)typeDescriptor
{

    id <TyphoonTypeConverter> converter = [_typeConverters objectForKey:[typeDescriptor classOrProtocol]];
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

- (void)register:(id <TyphoonTypeConverter>)converter;
{
    id classOrProtocol = [converter supportedType];
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

- (void)unregister:(id <TyphoonTypeConverter>)converter
{
    [_typeConverters removeObjectForKey:[converter supportedType]];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)registerSharedConverters
{
    [self register:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:NO]];
    [self register:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:YES]];
    [self register:[[TyphoonNSURLTypeConverter alloc] init]];
}

- (void)registerPlatformConverters
{
#if TARGET_OS_IPHONE
    {
        [self register:[[TyphoonUIColorTypeConverter alloc] init]];
        [self register:[[TyphoonBundledImageTypeConverter alloc] init]];
    }
#else
    {

    }
    #endif
}


@end
