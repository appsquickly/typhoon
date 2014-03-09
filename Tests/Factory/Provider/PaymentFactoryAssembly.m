////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "PaymentFactoryAssembly.h"

#import "AuthServiceImpl.h"
#import "CreditServiceImpl.h"
#import "PaymentFactory.h"
#import "PaymentImpl.h"
#import "PizzaFactory.h"
#import "PizzaImpl.h"

@implementation PaymentFactoryAssembly

- (id)authService
{
    return [TyphoonDefinition withClass:[AuthServiceImpl class] properties:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
        definition.lazy = YES;
    }];
}

- (id)creditService
{
    return [TyphoonDefinition withClass:[CreditServiceImpl class]];
}

- (id)paymentFactory
{
    return [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(authService)];
        [definition injectProperty:@selector(creditService)];
    } returns:[PaymentImpl class]];
}

- (id)pizzaFactory
{
    return [TyphoonFactoryProvider withProtocol:@protocol(PizzaFactory) dependencies:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(creditService)];
    } factories:^(TyphoonAssistedFactoryDefinition *definition) {
        [definition factoryMethod:@selector(pizzaWithRadius:ingredients:)
            body:^id(id <PizzaFactory> factory, double radius, NSArray *ingredients) {
                return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:radius ingredients:ingredients];
            }];
        [definition factoryMethod:@selector(smallPizzaWithIngredients:) body:^id(id <PizzaFactory> factory, NSArray *ingredients) {
            return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:1 ingredients:ingredients];
        }];
        [definition factoryMethod:@selector(mediumPizzaWithIngredients:) body:^id(id <PizzaFactory> factory, NSArray *ingredients) {
            return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:3 ingredients:ingredients];
        }];
        [definition factoryMethod:@selector(largePizzaWithIngredients:) body:^id(id <PizzaFactory> factory, NSArray *ingredients) {
            return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:5 ingredients:ingredients];
        }];
    }];
}

@end
