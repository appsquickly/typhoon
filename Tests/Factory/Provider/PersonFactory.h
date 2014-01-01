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

@protocol PersonFactory <NSObject>

@property (nonatomic, strong, readonly) id<CreditService> creditService;
@property (nonatomic, strong, readonly) id<AuthService> authService;

- (Person *)personWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

- (Person *)personWithFirstName:(NSString *)firstName;

// This factory method will use the initializer with 3 parameters
- (Person *)personWithLastName:(NSString *)lastName authService:(id<AuthService>)authService;

// Because this one fills less parameters with its own parameter will use the
// one with two parameters
- (Person *)personWithLastName:(NSString *)lastName;

@end
