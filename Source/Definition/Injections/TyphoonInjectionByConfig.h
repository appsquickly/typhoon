//
// Created by Aleksey Garbarev on 27.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonAbstractInjection.h"

@protocol TyphoonInjection;


@interface TyphoonInjectionByConfig : TyphoonAbstractInjection

@property (nonatomic, strong) id<TyphoonInjection> configuredInjection;
@property (nonatomic, strong, readonly) NSString *configKey;

- (instancetype)initWithConfigKey:(NSString *)configKey;

@end