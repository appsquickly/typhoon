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


#import "TyphoonInjectionByComponentFactory.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonIntrospectionUtils.h"

@implementation TyphoonInjectionByComponentFactory

#pragma mark - Overrides

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    result(context.factory);
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByComponentFactory *copied = [[TyphoonInjectionByComponentFactory alloc] init];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (BOOL)isEqualToCustom:(TyphoonInjectionByComponentFactory *)injection
{
    return YES;
}

@end
