//
//  TyphoonRuntimeArguments.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TyphoonRuntimeArguments : NSObject <NSCopying>

+ (instancetype)argumentsFromInvocation:(NSInvocation *)invocation;

+ (instancetype)argumentsFromVAList:(va_list)list selector:(SEL)selector DEPRECATED_ATTRIBUTE;

+ (instancetype)argumentsWithSelector:(SEL)selector arguments:(id)first, ...;

- (id)argumentValueAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfArgumentWithKind:(Class)clazz;

- (void)replaceArgumentAtIndex:(NSUInteger)index withArgument:(id)argument;

@end
