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

@protocol PizzaFactory <NSObject>

@property (nonatomic, strong, readonly) id<CreditService> creditService;

- (id<Pizza>)pizzaWithRadius:(double)radius ingredients:(NSArray *)ingrendients;
- (id<Pizza>)smallPizzaWithIngredients:(NSArray *)ingredients;
- (id<Pizza>)mediumPizzaWithIngredients:(NSArray *)ingredients;
- (id<Pizza>)largePizzaWithIngredients:(NSArray *)ingredients;

@end
