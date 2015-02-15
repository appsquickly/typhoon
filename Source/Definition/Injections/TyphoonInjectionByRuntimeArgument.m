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

#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonRuntimeArguments.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByRuntimeArgument

- (NSString *)customDescription
{
    return [NSString stringWithFormat:@"runtimeIndex = %d, ", (int)self.runtimeArgumentIndex];
}

- (instancetype)initWithArgumentIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        _runtimeArgumentIndex = index;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    [NSException raise:NSInvalidArgumentException
        format:@"You can't call a method on the runtime argument being passed in. It has to be passed in as-is"];
    return nil;
}

#pragma mark - Overrides

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    id<TyphoonInjection> injection = [context.args argumentValueAtIndex:self.runtimeArgumentIndex];
    [injection valueToInjectWithContext:context completion:result];
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByRuntimeArgument *copied = [[TyphoonInjectionByRuntimeArgument alloc] initWithArgumentIndex:self.runtimeArgumentIndex];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (BOOL)isEqualToCustom:(TyphoonInjectionByRuntimeArgument *)injection
{
    return self.runtimeArgumentIndex == injection.runtimeArgumentIndex;
}

- (NSUInteger)customHash
{
    return _runtimeArgumentIndex;
}

@end

