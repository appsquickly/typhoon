//
//  TyphoonParameterInjectedAtRuntime.m
//  Static Library
//
//  Created by Robert Gilliam on 8/1/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonParameterInjectedAtRuntime.h"


@implementation TyphoonParameterInjectedAtRuntime {
    NSUInteger runtimeArgumentIndex;
}

@synthesize runtimeArgumentIndex;

- (id)initWithParameterIndex:(NSUInteger)parameterIndex runtimeArgumentIndex:(NSUInteger)theRuntimeArgumentIndex
{
    self = [super init];
    if (!self) return nil;
    
    _index = parameterIndex;
    runtimeArgumentIndex = theRuntimeArgumentIndex;
    
    return self;
}

/* =========================================================== Protocol Methods ========================================================= */
- (TyphoonParameterInjectionType)type
{
    return TyphoonParameterInjectedAtRuntimeType;
}

- (void)setInitializer:(TyphoonInitializer*)initializer
{
    //Do nothing.
}

@end
