//
// Created by Aleksey Garbarev on 13.09.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonDefinition.h"


@interface TyphoonFactoryDefinition : TyphoonDefinition

@property (nonatomic, strong) id classOrProtocolForAutoInjection;

+ (id)withConfiguration:(void(^)(TyphoonFactoryDefinition *definition))injections;

@end