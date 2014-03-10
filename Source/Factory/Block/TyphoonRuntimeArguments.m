//
//  TyphoonRuntimeArguments.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonRuntimeArguments.h"

@implementation TyphoonRuntimeArguments {
    NSMutableArray *args;
    NSMethodSignature *signature;
    SEL selector;
}

+ (NSUInteger) numberOfArgumentsInSelector:(SEL)selector
{
    NSString *string = NSStringFromSelector(selector);
    uint count = 0;
    for (int i = 0; i < string.length; i++) {
        if ([string characterAtIndex:i] == ':')
            count++;
    }
    return count;
}

+ (instancetype) argumentsFromInvocation:(NSInvocation *)invocation
{
    NSUInteger argc = [self numberOfArgumentsInSelector:[invocation selector]];
    if (argc == 0) {
        return nil;
    }
    
    return [[self alloc] initWithInvocation:invocation];
}

- (id) initWithInvocation:(NSInvocation *)invocation
{
    /* Counting ':' because methodSignature always for 'componentForKey:args:' selector */
    NSUInteger argc = [[self class] numberOfArgumentsInSelector:[invocation selector]];
    if (argc == 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        args = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < argc; i++) {
            void *argument;
            [invocation getArgument:&argument atIndex:i+2];
            [args addObject:(__bridge id)argument];
        }
        selector = [invocation selector];
        signature = [invocation methodSignature];

    }
    return self;
}

- (id) argumentValueAtIndex:(NSUInteger)index
{
    return args[index];
}

@end
