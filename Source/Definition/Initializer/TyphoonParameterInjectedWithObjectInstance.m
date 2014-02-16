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

#import "TyphoonParameterInjectedWithObjectInstance.h"
#import "TyphoonInitializer.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "NSValue+TCFInstanceBuilder.h"

@implementation TyphoonParameterInjectedWithObjectInstance

- (id)initWithParameterIndex:(NSUInteger)index value:(id)value
{
    self = [super init];
    if (self) {
        _index = index;
        _value = value;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)withFactory:(TyphoonComponentFactory *)factory setArgumentOnInvocation:(NSInvocation *)invocation
{
    [self setObject:self.value forInvocation:invocation];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

/**
* Returns a copy. Does not copy the value, but returns a reference to it.
*/
- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonParameterInjectedWithObjectInstance alloc] initWithParameterIndex:_index value:_value];
}


@end
