//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonOptionMatcher.h"
#import "TyphoonDefinition+Option.h"

@class TyphoonComponentFactory;

typedef void(^TyphoonOptionMatcherDefinitionSearchResult)(TyphoonDefinition *definition, TyphoonRuntimeArguments *arguments);


@interface TyphoonOptionMatcher (Internal)

- (instancetype)initWithBlock:(TyphoonMatcherBlock)block;

- (void)findDefinitionMatchedValue:(id)value withFactory:(TyphoonComponentFactory *)factory usingBlock:(TyphoonOptionMatcherDefinitionSearchResult)block;

@end