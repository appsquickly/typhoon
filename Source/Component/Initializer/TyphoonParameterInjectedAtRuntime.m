//
//  TyphoonParameterInjectedAtRuntime.m
//  Static Library
//
//  Created by Robert Gilliam on 8/1/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonParameterInjectedAtRuntime.h"


@implementation TyphoonParameterInjectedAtRuntime

- (id)initWithParameterIndex:(NSUInteger)parameterIndex
{
    self = [super init];
    if (self)
    {
        _index = parameterIndex;
    }
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
