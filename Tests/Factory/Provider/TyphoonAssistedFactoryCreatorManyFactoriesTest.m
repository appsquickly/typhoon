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

#import <XCTest/XCTest.h>
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


@interface TyphoonAssistedFactoryCreatorManyFactoriesTest : XCTestCase
@end

@implementation TyphoonAssistedFactoryCreatorManyFactoriesTest
{
    Protocol *_pizzaFactoryProtocol;
    Protocol *_paymentFactoryProtocol;
    Class _pizzaFactoryClass;
    Class _paymentFactoryClass;

    id <CreditService> _creditService;
    id <AuthService> _authService;
}

- (void)setUp
{
    _creditService = (id <CreditService>) [[NSObject alloc] init];
    _authService = (id <AuthService>) [[NSObject alloc] init];
}

- (Protocol *)pizzaFactoryProtocol
{
    if (!_pizzaFactoryProtocol) {
        _pizzaFactoryProtocol = protocol_clone(@protocol(PizzaFactory));
    }

    return _pizzaFactoryProtocol;
}

- (Protocol *)paymentFactoryProtocol
{
    if (!_paymentFactoryProtocol) {
        _paymentFactoryProtocol = protocol_clone(@protocol(PaymentFactory));
    }

    return _paymentFactoryProtocol;
}

- (Class)pizzaFactoryClass
{
    if (!_pizzaFactoryClass) {
        _pizzaFactoryClass = [[[TyphoonAssistedFactoryCreatorManyFactories alloc]
            initWithProtocol:[self pizzaFactoryProtocol] factories:^(TyphoonAssistedFactoryDefinition *definition) {
                [definition factoryMethod:@selector(pizzaWithRadius:ingredients:)
                    body:^id(id <PizzaFactory> factory, double radius, NSArray *ingredients) {
                        return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:radius ingredients:ingredients];
                    }];
                [definition factoryMethod:@selector(smallPizzaWithIngredients:) body:^id(id <PizzaFactory> factory, NSArray *ingredients) {
                    return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:5.0 ingredients:ingredients];
                }];
                [definition factoryMethod:@selector(mediumPizzaWithIngredients:) body:^id(id <PizzaFactory> factory, NSArray *ingredients) {
                    return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:10.0 ingredients:ingredients];
                }];
                [definition factoryMethod:@selector(largePizzaWithIngredients:) body:^id(id <PizzaFactory> factory, NSArray *ingredients) {
                    return [[PizzaImpl alloc] initWithCreditService:factory.creditService radius:20.0 ingredients:ingredients];
                }];
            }] factoryClass];
    }

    return _pizzaFactoryClass;
}

- (Class)paymentFactoryClass
{
    if (!_paymentFactoryClass) {
        _paymentFactoryClass = [[[TyphoonAssistedFactoryCreatorManyFactories alloc]
            initWithProtocol:[self paymentFactoryProtocol] factories:^(TyphoonAssistedFactoryDefinition *definition) {
                [definition factoryMethod:@selector(paymentWithStartDate:amount:) returns:[PaymentImpl class]
                    initialization:^(TyphoonAssistedFactoryMethodInitializer *initializer) {
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

    XCTAssertTrue(class_conformsToProtocol(klass, [self paymentFactoryProtocol]));

    Class superklass = class_getSuperclass(klass);
    XCTAssertEqual(superklass, [TyphoonAssistedFactoryBase class]);
}

- (void)test_factory_should_respond_to_properties
{
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    XCTAssertTrue([factory respondsToSelector:@selector(creditService)]);
    XCTAssertTrue([factory respondsToSelector:@selector(authService)]);
}

- (void)test_factory_should_implement_properties
{
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    id mockCreditServiceInjectedProperty = mockProtocol(@protocol(TyphoonPropertyInjection));
    [given([mockCreditServiceInjectedProperty propertyName]) willReturn:@"creditService"];

    id mockAuthServiceInjectedProperty = mockProtocol(@protocol(TyphoonPropertyInjection));
    [given([mockAuthServiceInjectedProperty propertyName]) willReturn:@"authService"];

    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockCreditServiceInjectedProperty withType:nil lazyValue:^{ return _creditService; }];
    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockAuthServiceInjectedProperty withType:nil lazyValue:^{ return _authService; }];

    XCTAssertEqual(factory.creditService, _creditService);
    XCTAssertEqual(factory.authService, _authService);
}

- (void)test_factory_should_invoke_correct_method_blocks_1
{
    Class klass = [self pizzaFactoryClass];
    id <PizzaFactory> factory = [[klass alloc] init];

    id mockCreditServiceInjectedProperty = mockProtocol(@protocol(TyphoonPropertyInjection));
    [given([mockCreditServiceInjectedProperty propertyName]) willReturn:@"creditService"];

    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockCreditServiceInjectedProperty withType:nil lazyValue:^{ return _creditService; }];

    id <Pizza> pizza = [factory pizzaWithRadius:123.0 ingredients:@[
        @"1",
        @"2"
    ]];

    XCTAssertEqual(pizza.creditService, _creditService);
    XCTAssertEqual(pizza.radius, 123.0);
    NSSet *ingredients = [NSSet setWithArray:pizza.ingredients];
    XCTAssertTrue([ingredients count] == 2);
    XCTAssertNotNil([ingredients member:@"1"]);
    XCTAssertNotNil([ingredients member:@"2"]);

}

- (void)test_factory_should_invoke_correct_method_blocks_2
{
    Class klass = [self pizzaFactoryClass];
    id <PizzaFactory> factory = [[klass alloc] init];

    id mockCreditServiceInjectedProperty = mockProtocol(@protocol(TyphoonPropertyInjection));
    [given([mockCreditServiceInjectedProperty propertyName]) willReturn:@"creditService"];

    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockCreditServiceInjectedProperty withType:nil lazyValue:^{ return _creditService; }];

    id <Pizza> pizza = [factory smallPizzaWithIngredients:@[
        @"3",
        @"4"
    ]];

    XCTAssertEqual(pizza.creditService, _creditService);
    XCTAssertEqual(pizza.radius, 5.0);
    NSSet* ingredients = [NSSet setWithArray:pizza.ingredients];
    XCTAssertTrue([ingredients count] == 2);
    XCTAssertNotNil([ingredients member:@"3"]);
    XCTAssertNotNil([ingredients member:@"4"]);
}

- (void)test_factory_should_invoke_correct_initializers
{
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    id mockCreditServiceInjectedProperty = mockProtocol(@protocol(TyphoonPropertyInjection));
    [given([mockCreditServiceInjectedProperty propertyName]) willReturn:@"creditService"];

    id mockAuthServiceInjectedProperty = mockProtocol(@protocol(TyphoonPropertyInjection));
    [given([mockAuthServiceInjectedProperty propertyName]) willReturn:@"authService"];

    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockCreditServiceInjectedProperty withType:nil lazyValue:^{ return _creditService; }];
    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockAuthServiceInjectedProperty withType:nil lazyValue:^{ return _authService; }];

    NSDate *now = [NSDate date];
    id <Payment> payment = [factory paymentWithStartDate:now amount:456];

    XCTAssertEqual(payment.creditService, _creditService);
    XCTAssertEqual(payment.authService, _authService);
    XCTAssertEqual(payment.startDate, now);
    XCTAssertEqual(payment.amount, 456);
}

@end
