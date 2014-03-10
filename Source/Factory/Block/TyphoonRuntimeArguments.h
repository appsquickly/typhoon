//
//  TyphoonRuntimeArguments.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TyphoonRuntimeArguments : NSObject

+ (instancetype) argumentsFromInvocation:(NSInvocation *)invocation;

- (id) argumentValueAtIndex:(NSUInteger)index;

@end
