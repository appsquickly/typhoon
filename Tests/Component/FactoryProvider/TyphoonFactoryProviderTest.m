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

#import <SenTestingKit/SenTestingKit.h>
#import <objc/runtime.h>
#import "TyphoonAssistedFactoryBase.h"
#import "TyphoonFactoryProvider.h"
#import "TyphoonDefinition.h"
#import "PaymentFactory.h"
#import "PaymentImpl.h"
#import "PizzaFactory.h"
#import "PizzaImpl.h"

@interface TyphoonFactoryProviderTest : SenTestCase
@end

@implementation TyphoonFactoryProviderTest
{
    TyphoonDefinition *_pizzaFactoryDefinition;
    TyphoonDefinition *_paymentFactoryDefinition;

    id<CreditService> _creditService;
    id<AuthService> _authService;
}

- (void)setUp
{
    _creditService = (id<CreditService>)[[NSObject alloc] init];
    _authService = (id<AuthService>)[[NSObject alloc] init];
}

- (TyphoonDefinition *)pizzaFactoryDefinition
{
    if (!_pizzaFactoryDefinition)
    {
        _pizzaFactoryDefinition = [TyphoonFactoryProvider withProtocol:@protocol(PizzaFactory) dependencies:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(creditService) withObjectInstance:_creditService];
        } factories:^(TyphoonAssistedFactoryDefinition *definition) {
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
        }];
    }

    return _pizzaFactoryDefinition;
}

- (TyphoonDefinition *)paymentFactoryDefinition
{
    if (!_paymentFactoryDefinition)
    {
        _paymentFactoryDefinition = [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(creditService) withObjectInstance:_creditService];
            [definition injectProperty:@selector(authService) withObjectInstance:_authService];
        } factory:^id (id<PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
            return [[PaymentImpl alloc] initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
        }];
    }

    return _paymentFactoryDefinition;
}

- (void)test_factory_definition_should_be_right_class
{
    Class klass = [self pizzaFactoryDefinition].type;

    assertThatBool(class_conformsToProtocol(klass, @protocol(PizzaFactory)), is(equalToBool(YES)));

    Class superklass = class_getSuperclass(klass);
    assertThat(superklass, is([TyphoonAssistedFactoryBase class]));
}

- (void)test_factory_definition_should_have_injected_properties
{
    NSSet *injectedProperties = [self paymentFactoryDefinition].injectedProperties;

    NSMutableArray *injectedPropertyNames = [NSMutableArray array];
    [injectedProperties enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [injectedPropertyNames addObject:[obj name]];
    }];

    assertThat(injectedPropertyNames, hasCountOf(2));
    assertThat(injectedPropertyNames, hasItems(equalTo(@"creditService"), equalTo(@"authService"), nil));
}

- (void)test_factory_should_respond_to_properties
{
    Class klass = [self paymentFactoryDefinition].type;
    id<PaymentFactory> factory = [[klass alloc] init];

    assertThatBool([factory respondsToSelector:@selector(creditService)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(setCreditService:)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(authService)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(setAuthService:)], is(equalToBool(YES)));
}

- (void)test_factory_should_implement_properties
{
    Class klass = [self pizzaFactoryDefinition].type;
    id<PizzaFactory> factory = [[klass alloc] init];

    [(NSObject *)factory setValue:_creditService forKey:@"creditService"];
    assertThat(factory.creditService, is(_creditService));
}

- (void)test_factory_should_invoke_correct_method_blocks_1
{
    Class klass = [self pizzaFactoryDefinition].type;
    id<PizzaFactory> factory = [[klass alloc] init];

    [(NSObject *)factory setValue:_creditService forKey:@"creditService"];

    id<Pizza> pizza = [factory pizzaWithRadius:123.0 ingredients:@[@"1", @"2"]];

    assertThat(pizza.creditService, is(_creditService));
    assertThatDouble(pizza.radius, is(equalToDouble(123.0)));
    assertThat(pizza.ingredients, hasItems(equalTo(@"1"), equalTo(@"2"), nil));
}

- (void)test_factory_should_invoke_correct_method_blocks_2
{
    Class klass = [self pizzaFactoryDefinition].type;
    id<PizzaFactory> factory = [[klass alloc] init];

    [(NSObject *)factory setValue:_creditService forKey:@"creditService"];

    id<Pizza> pizza = [factory smallPizzaWithIngredients:@[@"3", @"4"]];

    assertThat(pizza.creditService, is(_creditService));
    assertThatDouble(pizza.radius, is(equalToDouble(5.0)));
    assertThat(pizza.ingredients, hasItems(equalTo(@"3"), equalTo(@"4"), nil));
}

- (void)test_factory_should_invoke_correct_method_blocks_3
{
    Class klass = [self paymentFactoryDefinition].type;
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
