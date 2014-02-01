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

#import "CreditService.h"
#import "Pizza.h"

@interface PizzaImpl : NSObject <Pizza>

@property (nonatomic, strong) id factory;

- (instancetype)initWithCreditService:(id<CreditService>)creditService
                               radius:(double)radius
                          ingredients:(NSArray *)ingredients;

@end
