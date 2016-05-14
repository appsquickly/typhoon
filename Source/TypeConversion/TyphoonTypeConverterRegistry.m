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


#import <objc/runtime.h>
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonPassThroughTypeConverter.h"
#import "TyphoonNSURLTypeConverter.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonNSNumberTypeConverter.h"

@interface TyphoonTypeConverterRegistry ()

@property (strong, nonatomic) TyphoonPrimitiveTypeConverter *primitiveTypeConverter;
@property (strong, nonatomic) NSMutableDictionary *typeConverters;

@end

@implementation TyphoonTypeConverterRegistry

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        _typeConverters = [[NSMutableDictionary alloc] init];
        _primitiveTypeConverter = [[TyphoonPrimitiveTypeConverter alloc] init];

        [self registerSharedConverters];
        [self registerPlatformConverters];
    }
    return self;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods

- (id <TyphoonTypeConverter>)converterForType:(NSString *)type
{
    return _typeConverters[type];
}

- (TyphoonPrimitiveTypeConverter *)primitiveTypeConverter
{
    return _primitiveTypeConverter;
}

- (void)registerTypeConverter:(id <TyphoonTypeConverter>)converter
{
    NSString *type = [converter supportedType];
    if (!(_typeConverters[type])) {
        _typeConverters[type] = converter;
    }
    else {
        [NSException raise:NSInvalidArgumentException format:@"Converter for '%@' already registered.", type];
    }
}

- (void)unregisterTypeConverter:(id <TyphoonTypeConverter>)converter
{
    [_typeConverters removeObjectForKey:[converter supportedType]];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)registerSharedConverters
{
    [self registerTypeConverter:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:NO]];
    [self registerTypeConverter:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:YES]];
    [self registerTypeConverter:[[TyphoonNSURLTypeConverter alloc] init]];
    [self registerTypeConverter:[[TyphoonNSNumberTypeConverter alloc] init]];
}

- (void)registerPlatformConverters
{
#if TARGET_OS_IPHONE || TARGET_OS_TV
    {
        [self registerTypeConverter:[[TyphoonClassFromString(@"TyphoonUIColorTypeConverter") alloc] init]];
        [self registerTypeConverter:[[TyphoonClassFromString(@"TyphoonBundledImageTypeConverter") alloc] init]];
    }
#else
    {
        [self registerTypeConverter:[[TyphoonClassFromString(@"TyphoonNSColorTypeConverter") alloc] init]];
    }
#endif
}


@end
