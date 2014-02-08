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



#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"


@implementation TyphoonParameterInjectedByReference

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithParameterIndex:(NSUInteger)index reference:(NSString*)reference
{
    self = [super init];
    if (self)
    {
        _index = index;
        _reference = reference;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)withFactory:(TyphoonComponentFactory*)factory setArgumentOnInvocation:(NSInvocation*)invocation
{
    [[[factory stack] peekForKey:_reference] instance]; //Raises circular dependencies exception if already initializing.
    id reference = [factory componentForKey:_reference];
    [invocation setArgument:&reference atIndex:_index + 2];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone*)zone
{
    return [[TyphoonParameterInjectedByReference alloc] initWithParameterIndex:_index reference:[_reference copy]];
}


@end
