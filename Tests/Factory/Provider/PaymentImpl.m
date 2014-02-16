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

#import "PaymentImpl.h"

@implementation PaymentImpl

@synthesize creditService = _creditService;
@synthesize authService = _authService;
@synthesize startDate = _startDate;
@synthesize amount = _amount;

- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    startDate:(NSDate *)startDate amount:(NSUInteger)amount
{
    self = [super init];
    if (self) {
        _creditService = creditService;
        _authService = authService;
        _startDate = startDate;
        _amount = amount;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p startDate:%@ amount:%lu>", [self class], self, _startDate, (unsigned long) _amount];
}

// Bogus implementations

- (void)initialize
{
}

- (instancetype)initWithCreditService:(id <CreditService>)creditService startDate:(NSDate *)startDate amount:(NSUInteger)amount
{
    return nil;
}

- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    startDate:(NSDate *)startDate
{
    return nil;
}

- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    startDate:(NSDate *)startDate amount:(NSUInteger)amount customerName:(NSString *)customerName
{
    return nil;
}

@end
