////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonParameterInjectedByComponentFactory.h"

@implementation TyphoonParameterInjectedByComponentFactory

/* ====================================================================================================================================== */
#pragma mark - Initialization

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex
{
    self = [super init];
    if (self) {
        _index = parameterIndex;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonParameterInjectedByComponentFactory alloc] initWithParameterIndex:_index];
}

- (void)withFactory:(TyphoonComponentFactory *)factory setArgumentOnInvocation:(NSInvocation *)invocation
{
    [self setObject:factory forInvocation:invocation];
}


@end
