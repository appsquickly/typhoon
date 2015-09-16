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
#import "TyphoonOptionMatcher.h"
#import "TyphoonDefinition+Option.h"

@class TyphoonComponentFactory;
@protocol TyphoonInjection;

@interface TyphoonOptionMatcher (Internal)

- (instancetype)initWithBlock:(TyphoonMatcherBlock)block;

- (id<TyphoonInjection>)injectionMatchedValue:(id)value;

@end
