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


@implementation TyphoonTypeConverterRegistry

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonTypeConverterRegistry *)shared
{
    static dispatch_once_t onceToken;
    static TyphoonTypeConverterRegistry *instance;

    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (NSString *)typeFromTextValue:(NSString *)textValue
{
    NSString *type = nil;

    NSRange openBraceRange = [textValue rangeOfString:@"("];
    BOOL hasBraces = [textValue hasSuffix:@")"] && openBraceRange.location != NSNotFound;
    if (hasBraces) {
        type = [textValue substringToIndex:openBraceRange.location];
    }

    return type;
}

+ (NSString *)textWithoutTypeFromTextValue:(NSString *)textValue
{
    NSString *result = textValue;

    NSRange openBraceRange = [textValue rangeOfString:@"("];
    BOOL hasBraces = [textValue hasSuffix:@")"] && openBraceRange.location != NSNotFound;

    if (hasBraces) {
        NSRange range = NSMakeRange(openBraceRange.location + openBraceRange.length, 0);
        range.length = [textValue length] - range.location - 1;
        result = [textValue substringWithRange:range];
    }

    return result;
}

/* ====================================================================================================================================== */
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


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (id <TyphoonTypeConverter>)converterForType:(NSString *)type
{
    return [_typeConverters objectForKey:type];
}

- (TyphoonPrimitiveTypeConverter *)primitiveTypeConverter
{
    return _primitiveTypeConverter;
}

- (void)registerTypeConverter:(id <TyphoonTypeConverter>)converter
{
    NSString *type = [converter supportedType];
    if (!([_typeConverters objectForKey:type])) {
        [_typeConverters setObject:converter forKey:type];
    }
    else {
        [NSException raise:NSInvalidArgumentException format:@"Converter for '%@' already registered.", type];
    }
}

- (void)unregisterTypeConverter:(id <TyphoonTypeConverter>)converter
{
    [_typeConverters removeObjectForKey:[converter supportedType]];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)registerSharedConverters
{
    [self registerTypeConverter:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:NO]];
    [self registerTypeConverter:[[TyphoonPassThroughTypeConverter alloc] initWithIsMutable:YES]];
    [self registerTypeConverter:[[TyphoonNSURLTypeConverter alloc] init]];
}

- (void)registerPlatformConverters
{
#if TARGET_OS_IPHONE
    {
        [self registerTypeConverter:[[NSClassFromString(@"TyphoonUIColorTypeConverter") alloc] init]];
        [self registerTypeConverter:[[NSClassFromString(@"TyphoonBundledImageTypeConverter") alloc] init]];
    }
#else
    {

    }
#endif
}


@end
