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

#import "TyphoonPropertyInjectedByComponentFactory.h"

@implementation TyphoonPropertyInjectedByComponentFactory

/* ====================================================================================================================================== */
#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overrides

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance
{
    return factory;
}

@end
