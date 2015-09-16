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


#import "TyphoonPathResource.h"


@implementation TyphoonPathResource
{
    NSString *_path;
    NSData *_data;
}

+ (id<TyphoonResource>)withPath:(NSString *)filePath
{
    return [[TyphoonPathResource alloc] initWithContentsOfFile:filePath];
}

- (instancetype)initWithContentsOfFile:(NSString *)filePath
{
    self = [super init];
    if (self) {
        _path = filePath;
        _data = [[NSData alloc] initWithContentsOfFile:filePath];
    }
    return self;
}

- (NSString *)asString
{
    return [self asStringWithEncoding:NSUTF8StringEncoding];
}

- (NSString *)asStringWithEncoding:(NSStringEncoding)encoding
{
    return [[NSString alloc] initWithData:_data encoding:encoding];
}

- (NSData *)data
{
    return _data;
}

- (NSURL *)url
{
    return [NSURL fileURLWithPath:_path];
}

- (NSString *)description
{
    return _path.lastPathComponent;
}


@end
