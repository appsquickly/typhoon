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

#import <XCTest/XCTest.h>

#import "AuthServiceImpl.h"
#import "CreditServiceImpl.h"
#import "PaymentFactory.h"
#import "PaymentFactoryAssembly.h"
#import "PaymentImpl.h"
#import "PizzaFactory.h"
#import "PizzaImpl.h"

@interface TyphoonFactoryProviderIntegrationTest : XCTestCase
@end

@implementation TyphoonFactoryProviderIntegrationTest
{
    TyphoonBlockComponentFactory *componentFactory;
    PaymentFactoryAssembly *assembly;
}

- (void)setUp
{
    componentFactory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[PaymentFactoryAssembly assembly]];
    assembly = (PaymentFactoryAssembly *) componentFactory;
}

- (void)test_dependencies_are_built_lazily
{
    NSUInteger authServiceInstanceCounter = [AuthServiceImpl instanceCounter];
    NSUInteger creditServiceInstanceCounter = [CreditServiceImpl instanceCounter];

    id <PaymentFactory> factory = [assembly paymentFactory];

    assertThatUnsignedInteger([CreditServiceImpl instanceCounter], is(equalToUnsignedInteger(creditServiceInstanceCounter)));

    assertThatUnsignedInteger([AuthServiceImpl instanceCounter], is(equalToUnsignedInteger(authServiceInstanceCounter)));

    // No need for the return value.
    [factory paymentWithStartDate:[NSDate date] amount:123];

    assertThatUnsignedInteger([AuthServiceImpl instanceCounter], is(equalToUnsignedInteger(authServiceInstanceCounter + 1)));
    assertThatUnsignedInteger([CreditServiceImpl instanceCounter], is(equalToUnsignedInteger(creditServiceInstanceCounter + 1)));
}

- (void)test_assisted_factory_is_TyphoonComponentFactoryAware
{
    NSObject <PaymentFactory> *factory = [assembly paymentFactory];

    id cf = [factory valueForKey:@"componentFactory"];
    assertThat(cf, is(equalTo(componentFactory)));
}

- (void)test_assisted_initializer_factory_injects_component_factory_in_object_instances
{
    id <PaymentFactory> factory = [assembly paymentFactory];

    PaymentImpl *payment = (PaymentImpl *) [factory paymentWithStartDate:[NSDate date] amount:456];

    assertThat(payment.factory, is(equalTo(componentFactory)));
}

- (void)test_assisted_block_factory_injects_component_factory_in_object_instances
{
    id <PizzaFactory> factory = [assembly pizzaFactory];

    PizzaImpl *pizza = (PizzaImpl *) [factory largePizzaWithIngredients:@[
        @"bacon",
        @"cheese"
    ]];

    assertThat(pizza.factory, is(equalTo(componentFactory)));
}

- (void)test_assisted_factory_doesnt_blow_up_when_calling_one_of_the_methods
{
    @autoreleasepool {
        id <PaymentFactory> factory1;

        @autoreleasepool {
            factory1 = [assembly paymentFactory];

            id <Payment> payment1 = [factory1 paymentWithStartDate:[NSDate date] amount:123];

            assertThat(payment1, is(notNilValue()));
        }

        id <Payment> payment2 = [factory1 paymentWithStartDate:[NSDate date] amount:456];

        assertThat(payment2, is(notNilValue()));
    }

    @autoreleasepool {
        id <PizzaFactory> factory2;

        @autoreleasepool {
            factory2 = [assembly pizzaFactory];

            id <Pizza> pizza1 = [factory2 pizzaWithRadius:789.123 ingredients:@[
                @"Cheese",
                @"Ham"
            ]];

            assertThat(pizza1, is(notNilValue()));
        }

        id <Pizza> pizza2 = [factory2 largePizzaWithIngredients:@[@"Bacon"]];

        assertThat(pizza2, is(notNilValue()));
    }
}

- (void)test_assisted_factory_honors_prototype_and_singleton_scopes
{
    id <PaymentFactory> factory = [assembly paymentFactory];

    PaymentImpl *payment1 = (PaymentImpl *) [factory paymentWithStartDate:[NSDate date] amount:456];
    PaymentImpl *payment2 = (PaymentImpl *) [factory paymentWithStartDate:[NSDate date] amount:789];

    assertThat(payment1.authService, is(equalTo(payment2.authService)));
    assertThat(payment1.creditService, isNot(equalTo(payment2.creditService)));
}

@end
