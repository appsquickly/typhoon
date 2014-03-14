//
//  TyphoonRuntimeArguments.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonRuntimeArguments.h"
#import "TyphoonIntrospectionUtils.h"

@interface TyphoonRuntimeNullArgument : NSObject
@end
@implementation TyphoonRuntimeNullArgument
@end

@implementation TyphoonRuntimeArguments {
    NSMutableArray *arguments;
}

+ (instancetype)argumentsFromInvocation:(NSInvocation *)invocation
{
    NSUInteger count = [[invocation methodSignature] numberOfArguments];
    if (count <= 2) {
        return nil;
    }
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 2; i < count; i++) {
        void *pointer;
        [invocation getArgument:&pointer atIndex:i];
        id argument = (__bridge id)pointer;
        if (argument) {
            [args addObject:argument];
        } else {
            [args addObject:[TyphoonRuntimeNullArgument new]];
        }
    }
    
    return [[self alloc] initWithArguments:args];
}

+ (instancetype)argumentsFromVAList:(va_list)list selector:(SEL)selector
{
    NSUInteger count = [TyphoonIntrospectionUtils numberOfArgumentsInSelector:selector];
    if (count == 0) {
        return nil;
    }
    
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        id argument = va_arg(list, id);
        if (argument) {
            [args addObject:argument];
        } else {
            [args addObject:[TyphoonRuntimeNullArgument new]];
        }
    }
    return [[self alloc] initWithArguments:args];
}

- (id)initWithArguments:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        arguments = array;
    }
    return self;
}

- (id)argumentValueAtIndex:(NSUInteger)index
{
    id argument = arguments[index];
    if ([argument isMemberOfClass:[TyphoonRuntimeNullArgument class]]) {
        return nil;
    } else {
        return argument;
    }
}

- (void)replaceArgumentAtIndex:(NSUInteger)index withArgument:(id)argument
{
    [arguments replaceObjectAtIndex:index withObject:argument];
}

- (NSUInteger)indexOfArgumentWithKind:(Class)clazz
{
    return [arguments indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL found = NO;
        if ([obj isKindOfClass:clazz]) {
            *stop = YES;
            found = YES;
        }
        return found;
    }];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonRuntimeArguments alloc] initWithArguments:[arguments mutableCopy]];
}

@end
