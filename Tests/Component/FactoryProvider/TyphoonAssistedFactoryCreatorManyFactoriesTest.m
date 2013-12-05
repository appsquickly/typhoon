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

#import "TyphoonAssistedFactoryCreatorManyFactories.h"

#import <SenTestingKit/SenTestingKit.h>
#include <objc/runtime.h>

#import "TyphoonFactoryProviderTestHelper.h"

#import "AuthService.h"
#import "CreditService.h"
#import "PaymentFactory.h"
#import "PaymentImpl.h"
#import "PizzaFactory.h"
#import "PizzaImpl.h"
#import "TyphoonAssistedFactoryBase.h"
#import "TyphoonDefinition.h"


@interface TyphoonAssistedFactoryCreatorManyFactoriesTest : SenTestCase
@end

@implementation TyphoonAssistedFactoryCreatorManyFactoriesTest
{
    Protocol *_pizzaFactoryProtocol;
    Protocol *_paymentFactoryProtocol;
    Class _pizzaFactoryClass;
    Class _paymentFactoryClass;

    id<CreditService> _creditService;
    id<AuthService> _authService;
}

- (void)setUp
{
    _creditService = (id<CreditService>)[[NSObject alloc] init];
    _authService = (id<AuthService>)[[NSObject alloc] init];
}

- (Protocol *)pizzaFactoryProtocol
{
    if (!_pizzaFactoryProtocol)
    {
        _pizzaFactoryProtocol = protocol_clone(@protocol(PizzaFactory));
    }

    return _pizzaFactoryProtocol;
}

- (Protocol *)paymentFactoryProtocol
{
    if (!_paymentFactoryProtocol)
    {
        _paymentFactoryProtocol = protocol_clone(@protocol(PaymentFactory));
    }

    return _paymentFactoryProtocol;
}

- (Class)pizzaFactoryClass
{
    if (!_pizzaFactoryClass)
    {
        _pizzaFactoryClass = [[[TyphoonAssistedFactoryCreatorManyFactories alloc] initWithProtocol:[self pizzaFactoryProtocol] factories:^(TyphoonAssistedFactoryDefinition *definition) {
            [definition factoryMethod:@selector(pizzaWithRadius:ingredients:) body:^id (id<PizzaFactory> factory, double radius, NSArray *ingredients) {
                return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:radius ingredients:ingredients];
            }];
            [definition factoryMethod:@selector(smallPizzaWithIngredients:) body:^id (id<PizzaFactory> factory, NSArray *ingredients) {
                return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:5.0 ingredients:ingredients];
            }];
            [definition factoryMethod:@selector(mediumPizzaWithIngredients:) body:^id (id<PizzaFactory> factory, NSArray *ingredients) {
                return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:10.0 ingredients:ingredients];
            }];
            [definition factoryMethod:@selector(largePizzaWithIngredients:) body:^id (id<PizzaFactory> factory, NSArray *ingredients) {
                return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:20.0 ingredients:ingredients];
            }];
        }] factoryClass];
    }

    return _pizzaFactoryClass;
}

- (Class)paymentFactoryClass
{
    if (!_paymentFactoryClass)
    {
        _paymentFactoryClass = [[[TyphoonAssistedFactoryCreatorManyFactories alloc] initWithProtocol:[self paymentFactoryProtocol] factories:^(TyphoonAssistedFactoryDefinition *definition) {
            [definition factoryMethod:@selector(paymentWithStartDate:amount:) returns:[PaymentImpl class] initialization:^(TyphoonAssistedFactoryMethodInitializer *initializer) {
                initializer.selector = @selector(initWithCreditService:authService:startDate:amount:);
                [initializer injectWithProperty:@selector(creditService)];
                [initializer injectWithProperty:@selector(authService)];
                [initializer injectWithArgumentNamed:@"startDate"];
                [initializer injectWithArgumentNamed:@"amount"];
            }];
        }] factoryClass];
    }

    return _paymentFactoryClass;
}

- (void)test_factory_class_should_implement_protocol
{
    Class klass = [self paymentFactoryClass];

    assertThatBool(class_conformsToProtocol(klass, [self paymentFactoryProtocol]), is(equalToBool(YES)));

    Class superklass = class_getSuperclass(klass);
    assertThat(superklass, is([TyphoonAssistedFactoryBase class]));
}

- (void)test_factory_should_respond_to_properties
{
    Class klass = [self paymentFactoryClass];
    id<PaymentFactory> factory = [[klass alloc] init];

    assertThatBool([factory respondsToSelector:@selector(creditService)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(setCreditService:)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(authService)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(setAuthService:)], is(equalToBool(YES)));
}

- (void)test_factory_should_implement_properties
{
    Class klass = [self paymentFactoryClass];
    id<PaymentFactory> factory = [[klass alloc] init];

    [(NSObject *)factory setValue:_creditService forKey:@"creditService"];
    [(NSObject *)factory setValue:_authService forKey:@"authService"];
    assertThat(factory.creditService, is(_creditService));
    assertThat(factory.authService, is(_authService));
}

- (void)test_factory_should_invoke_correct_method_blocks_1
{
    Class klass = [self pizzaFactoryClass];
    id<PizzaFactory> factory = [[klass alloc] init];

    [(NSObject *)factory setValue:_creditService forKey:@"creditService"];

    id<Pizza> pizza = [factory pizzaWithRadius:123.0 ingredients:@[@"1", @"2"]];

    assertThat(pizza.creditService, is(_creditService));
    assertThatDouble(pizza.radius, is(equalToDouble(123.0)));
    assertThat(pizza.ingredients, hasItems(equalTo(@"1"), equalTo(@"2"), nil));
}

- (void)test_factory_should_invoke_correct_method_blocks_2
{
    Class klass = [self pizzaFactoryClass];
    id<PizzaFactory> factory = [[klass alloc] init];

    [(NSObject *)factory setValue:_creditService forKey:@"creditService"];

    id<Pizza> pizza = [factory smallPizzaWithIngredients:@[@"3", @"4"]];

    assertThat(pizza.creditService, is(_creditService));
    assertThatDouble(pizza.radius, is(equalToDouble(5.0)));
    assertThat(pizza.ingredients, hasItems(equalTo(@"3"), equalTo(@"4"), nil));
}

- (void)test_factory_should_invoke_correct_initializers
{
    Class klass = [self paymentFactoryClass];
    id<PaymentFactory> factory = [[klass alloc] init];

    [(NSObject *)factory setValue:_creditService forKey:@"creditService"];
    [(NSObject *)factory setValue:_authService forKey:@"authService"];

    NSDate *now = [NSDate date];
    id<Payment> payment = [factory paymentWithStartDate:now amount:456];

    assertThat(payment.creditService, is(_creditService));
    assertThat(payment.authService, is(_authService));
    assertThat(payment.startDate, is(now));
    assertThatInteger(payment.amount, is(equalToInteger(456)));
}

@end
