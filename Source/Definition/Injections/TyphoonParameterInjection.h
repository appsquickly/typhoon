//
//  TyphoonParameterInjection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjection.h"

@protocol TyphoonParameterInjection <TyphoonInjection>

- (void)setParameterIndex:(NSUInteger)index;
- (NSUInteger)parameterIndex;

@end
