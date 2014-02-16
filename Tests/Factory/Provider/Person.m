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

#import "Person.h"

@implementation Person

- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    firstName:(NSString *)firstName lastName:(NSString *)lastName
{
    if (self = [super init]) {
        _usedInitializer = _cmd;
    }

    return self;
}


- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    firstName:(NSString *)firstName
{
    if (self = [super init]) {
        _usedInitializer = _cmd;
    }

    return self;
}

- (instancetype)initWithCreditService:(id <CreditService>)creditService firstName:(NSString *)firstName
{
    if (self = [super init]) {
        _usedInitializer = _cmd;
    }

    return self;
}

- (instancetype)initWithCreditService:(id <CreditService>)creditService authService:(id <AuthService>)authService
    lastName:(NSString *)lastName
{
    if (self = [super init]) {
        _usedInitializer = _cmd;
    }

    return self;
}

- (instancetype)initWithCreditService:(id <CreditService>)creditService lastName:(NSString *)lastName
{
    if (self = [super init]) {
        _usedInitializer = _cmd;
    }

    return self;
}

@end
