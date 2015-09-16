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

#import "TyphoonInjectionByCurrentRuntimeArguments.h"


@implementation TyphoonInjectionByCurrentRuntimeArguments

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    result(context.args);
}


- (id)copyWithZone:(NSZone *)zone
{
    id copied = [[self class] new];
    [self copyBasePropertiesTo:copied];
    return copied;
}

@end
