//
// Created by Aleksey Garbarev on 22.07.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mock : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, strong) Class clazz;
@property (nonatomic, strong) void(^block)();

- (instancetype)initWithObject:(id)object clazz:(Class)clazz block:(void (^)())block;


@end