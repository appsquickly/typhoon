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

#import "PizzaImpl.h"

@implementation PizzaImpl

@synthesize creditService = _creditService;
@synthesize radius = _radius;
@synthesize ingredients = _ingredients;

- (instancetype)initWithCreditService:(id<CreditService>)creditService radius:(double)radius ingredients:(NSArray *)ingredients
{
    self = [super init];
    if (self)
    {
        _creditService = creditService;
        _radius = radius;
        _ingredients = [ingredients copy];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p radius:%f ingredients:%lu>",
            [self class], self,
            _radius, (unsigned long)[_ingredients count]];
}

@end
