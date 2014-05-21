//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonOptionMatcher.h"
#import "TyphoonDefinition+Option.h"

@class TyphoonComponentFactory;

@interface TyphoonOptionMatcher (Internal)

- (instancetype)initWithBlock:(TyphoonMatcherBlock)block;

- (TyphoonDefinition *)definitionMatchingValue:(id)value withComponentFactory:(TyphoonComponentFactory *)factory;

@end