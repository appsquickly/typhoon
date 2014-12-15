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

#import "TyphoonAbstractInjection.h"

@interface TyphoonInjectionByRuntimeArgument : TyphoonAbstractInjection

@property(nonatomic, readonly) NSUInteger runtimeArgumentIndex;

/* index is zero-based */
- (instancetype)initWithArgumentIndex:(NSUInteger)index;

@end
