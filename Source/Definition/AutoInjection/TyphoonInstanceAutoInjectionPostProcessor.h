//
// Created by Aleksey Garbarev on 29.11.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonInstancePostProcessor.h"

@class TyphoonComponentFactory;
@class TyphoonDefinitionAutoInjectionPostProcessor;


@interface TyphoonInstanceAutoInjectionPostProcessor : NSObject <TyphoonInstancePostProcessor>

@property (nonatomic, strong) TyphoonComponentFactory *factory;
@property (nonatomic, strong) TyphoonDefinitionAutoInjectionPostProcessor *definitionPostProcessor;

@end