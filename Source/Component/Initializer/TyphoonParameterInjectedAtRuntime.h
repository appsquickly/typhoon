//
//  TyphoonParameterInjectedAtRuntime.h
//  Static Library
//
//  Created by Robert Gilliam on 8/1/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonInjectedParameter.h"

@interface TyphoonParameterInjectedAtRuntime : NSObject  <TyphoonInjectedParameter>

@property (nonatomic, readonly) NSUInteger index;

- (id)initWithParameterIndex:(NSUInteger)parameterIndex runtimeArgumentIndex:(NSUInteger)runtimeArgumentIndex;

@property (nonatomic, readonly) NSUInteger runtimeArgumentIndex;

@end
