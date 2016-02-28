////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonConfigPostProcessor.h"

@protocol TyphoonInjection;
@class TyphoonInjectionContext;
@class TyphoonInjectionByConfig;


@interface TyphoonConfigPostProcessor ()

- (BOOL)shouldInjectDefinition:(TyphoonDefinition *)definition;

- (id<TyphoonInjection>)injectionForConfigInjection:(TyphoonInjectionByConfig *)injection;

@end
