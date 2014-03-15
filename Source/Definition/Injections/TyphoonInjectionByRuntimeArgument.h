//
//  TyphoonInjectionByRuntimeArgument.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"

@interface TyphoonInjectionByRuntimeArgument : TyphoonAbstractInjection

@property(nonatomic, readonly) NSUInteger runtimeArgumentIndex;

/* index is zero-based */
- (instancetype)initWithArgumentIndex:(NSUInteger)index;

@end
