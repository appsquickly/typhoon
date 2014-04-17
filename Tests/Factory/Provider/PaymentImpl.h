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

@property(nonatomic, strong, setter = typhoonSetFactory:) id factory;

- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    startDate:(NSDate *)startDate amount:(NSUInteger)amount;

// This methods are to check some parts of the implementation

// Starts by init, but not by init + upper case.
- (void)initialize;

// Doesn't use as many properties as the main one.
- (instancetype)initWithCreditService:(id <CreditService>)creditService startDate:(NSDate *)startDate amount:(NSUInteger)amount;

// Doesn't use as many arguments as the main one.
- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    startDate:(NSDate *)startDate;

// Has one argument the factory cannot fullfil
- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    startDate:(NSDate *)startDate amount:(NSUInteger)amount customerName:(NSString *)customerName;

@end
