//
//  TyphoonParameterInjectedByRowValue.m
//  Typhoon
//
//  Created by Иван Ушаков on 23.05.13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonParameterInjectedByRawValue.h"

@implementation TyphoonParameterInjectedByRawValue

- (id)initWithParameterIndex:(NSUInteger)index value:(id)value
{
    self = [super init];
    if (self) {
        _index = index;
        _value = value;        
    }
    return self;
}

- (TyphoonParameterInjectionType)type
{
    return TyphoonParameterInjectedByRawValueType;
}

- (void)setInitializer:(TyphoonInitializer*)initializer
{
    //Do nothing.
}

@end
