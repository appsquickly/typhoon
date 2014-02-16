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

#import "TyphoonAssistedFactoryParameterInjectedWithArgumentIndex.h"

@implementation TyphoonAssistedFactoryParameterInjectedWithArgumentIndex

#pragma mark - Initializers & dealloc

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex argumentIndex:(NSUInteger)argumentIndex
{
    self = [super init];
    if (self) {
        _parameterIndex = parameterIndex;
        _argumentIndex = argumentIndex;
    }

    return self;
}

@end
