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

#import <Foundation/Foundation.h>


@interface Mock : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, strong) Class clazz;
@property (nonatomic, strong) void(^block)();

- (instancetype)initWithObject:(id)object clazz:(Class)clazz block:(void (^)())block;


@end