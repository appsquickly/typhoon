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

#import <Foundation/Foundation.h>
#import "AuthService.h"
#import "CreditService.h"
#import "Payment.h"

@interface PaymentImpl : NSObject <Payment>

- (instancetype)initWithCreditService:(id<CreditService>)creditService
                          authService:(id<AuthService>)authService
                            startDate:(NSDate *)startDate
                               amount:(NSUInteger)amount;

@end
