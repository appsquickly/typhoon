//
// Created by Aleksey Garbarev on 27.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonResource.h"

@interface TyphoonPathResource : NSObject<TyphoonResource>

+ (id <TyphoonResource>)withPath:(NSString *)filePath;

- (instancetype)initWithContentsOfFile:(NSString *)filePath;

@end