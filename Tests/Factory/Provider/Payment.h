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

#import "Typhoon.h"

@protocol Payment <NSObject>

@property(nonatomic, strong, readonly) id <CreditService> creditService;
@property(nonatomic, strong, readonly) id <AuthService> authService;
@property(nonatomic, strong, readonly) NSDate *startDate;
@property(nonatomic, assign, readonly) NSUInteger amount;

@end
