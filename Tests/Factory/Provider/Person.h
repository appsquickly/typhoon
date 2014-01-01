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

@protocol CreditService;
@protocol AuthService;

@interface Person : NSObject

@property (nonatomic, assign, readonly) SEL usedInitializer;

- (instancetype)initWithCreditService:(id<CreditService>)creditService
                          authService:(id<AuthService>)authService
                            firstName:(NSString *)firstName
                             lastName:(NSString *)lastName;


- (instancetype)initWithCreditService:(id<CreditService>)creditService
                          authService:(id<AuthService>)authService
                            firstName:(NSString *)firstName;

// This initializer will be discarded in favor of the one above
- (instancetype)initWithCreditService:(id<CreditService>)creditService
                            firstName:(NSString *)firstName;


- (instancetype)initWithCreditService:(id<CreditService>)creditService
                          authService:(id<AuthService>)authService
                             lastName:(NSString *)lastName;

- (instancetype)initWithCreditService:(id<CreditService>)creditService
                             lastName:(NSString *)lastName;

@end