//
// Created by Aleksey Garbarev on 27.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPathResource.h"


@implementation TyphoonPathResource
{
    NSData *_data;
}

+ (id <TyphoonResource>)withPath:(NSString *)filePath
{
    return [[[self class] alloc] initWithContentsOfFile:filePath];
}

- (instancetype)initWithContentsOfFile:(NSString *)filePath
{
    self = [super init];
    if (self) {
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

@end