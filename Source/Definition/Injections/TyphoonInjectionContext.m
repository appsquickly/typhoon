//
//  TyphoonInjectionContext.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 25.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionContext.h"

@implementation TyphoonInjectionContext

- (void)setPropertiesToCopy:(TyphoonInjectionContext *)copied
{
    copied.factory = self.factory;
    copied.args = self.args;
    copied.destinationType = self.destinationType;
    copied.destinationInstanceClass = self.destinationInstanceClass;
    copied.raiseExceptionIfCircular = self.raiseExceptionIfCircular;
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionContext *copied = [[TyphoonInjectionContext allocWithZone:zone] init];
    [self setPropertiesToCopy:copied];
    return copied;
}

+ (id)new
{
    return [super new];
}

- (id)copy
{
    return [super copy];
}

- (id)copyWithPool:(TyphoonInjectionContextPool *)pool
{
    TyphoonInjectionContext *reused = [pool dequeueReusableContext];
    [self setPropertiesToCopy:reused];
    return reused;
}


@end

@implementation TyphoonInjectionContextPool {
    NSMutableSet *reusableObjects;
}

+ (id)shared
{
    static TyphoonInjectionContextPool *sharedPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    	sharedPool = [TyphoonInjectionContextPool new];
    });
    return sharedPool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        reusableObjects = [[NSMutableSet alloc] initWithCapacity:10];
    }
    return self;
}


- (TyphoonInjectionContext *)dequeueReusableContext
{
    TyphoonInjectionContext *context = [reusableObjects anyObject];
    if (context) {
        [reusableObjects removeObject:context];
    } else {
        context = [TyphoonInjectionContext new];
    }
    return context;
}

- (void)enqueueReusableContext:(TyphoonInjectionContext *)context
{
    context.factory = nil;
    context.args = nil;
    context.destinationType = nil;
    context.destinationInstanceClass = nil;
    context.raiseExceptionIfCircular = NO;
    [reusableObjects addObject:context];
}

@end