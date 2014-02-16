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

#import "TyphoonAssistedFactoryParameterInjectedWithProperty.h"

@implementation TyphoonAssistedFactoryParameterInjectedWithProperty

#pragma mark - Initializers & deallocs

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex property:(SEL)property
{
    self = [super init];
    if (self) {
        _parameterIndex = parameterIndex;
        _property = property;
    }

    return self;
}

@end
