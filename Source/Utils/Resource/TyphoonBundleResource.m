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


#import "TyphoonBundleResource.h"


@implementation TyphoonBundleResource

/* =========================================================== Class Methods ============================================================ */
+ (id <TyphoonResource>)withName:(NSString*)name
{
    NSString* filePath = [self filePathForName:name];

    if (filePath == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Resource named '%@' not in bundle.", name];
    }

    return [[[self class] alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
}

+ (NSString*)filePathForName:(NSString*)name
{
    return [[NSBundle bundleForClass:[self class]] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
}

/* ============================================================ Initializers ============================================================ */
- (id)initWithData:(NSData*)data
{
    self = [super init];
    if (self)
    {
        _data = data;
    }
    return self;
}

- (NSString*)asString
{
    return [self asStringWithEncoding:NSUTF8StringEncoding];
}

- (NSString*)asStringWithEncoding:(NSStringEncoding)encoding
{
    return [[NSString alloc] initWithData:_data encoding:encoding];
}

- (NSData*)data
{
    return _data;
}


@end
