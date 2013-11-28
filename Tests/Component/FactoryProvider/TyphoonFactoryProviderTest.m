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


static Protocol *protocol_clone(Protocol *original)
{
    static int counter = 0;

    NSString *protocolName = [NSString stringWithFormat:@"%s%d", protocol_getName(original), counter++];
    Protocol *protocol = objc_allocateProtocol([protocolName UTF8String]);

    unsigned int count = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(original, YES, YES, &count);
    for (unsigned int idx = 0; idx < count; idx++) protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, YES, YES);
    free(methods);

    methods = protocol_copyMethodDescriptionList(original, YES, NO, &count);
    for (unsigned int idx = 0; idx < count; idx++) protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, YES, NO);
    free(methods);

    methods = protocol_copyMethodDescriptionList(original, NO, YES, &count);
    for (unsigned int idx = 0; idx < count; idx++) protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, NO, YES);
    free(methods);

    methods = protocol_copyMethodDescriptionList(original, NO, NO, &count);
    for (unsigned int idx = 0; idx < count; idx++) protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, NO, NO);
    free(methods);

    objc_property_t *properties = protocol_copyPropertyList(original, &count);
    for (unsigned int idx = 0; idx < count; idx++) {
        const char *name = property_getName(properties[idx]);
        unsigned int count2 = 0;
        objc_property_attribute_t *attrs = property_copyAttributeList(properties[idx], &count2);
        // FIXME: the fifth parameter is require/optional. I haven't seen
        // optional properties that much, and since this is just a helper method
        // I don't see the need to support optional properties.
        protocol_addProperty(protocol, name, attrs, count, YES, YES);
        free(attrs);
    }
    free(properties);

    Protocol *__unsafe_unretained *protocols = protocol_copyProtocolList(original, &count);
    for (unsigned int idx = 0; idx < count; idx++) protocol_addProtocol(protocol, protocols[idx]);
    free(protocols);

    objc_registerProtocol(protocol);

    return objc_getProtocol([protocolName UTF8String]);
}

@interface TyphoonFactoryProviderTest : SenTestCase
@end

@implementation TyphoonFactoryProviderTest
{
    Protocol *_pizzaFactoryProtocol;
    Protocol *_paymentFactoryProtocol;

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

- (TyphoonDefinition *)pizzaFactoryDefinition
{
    if (!_pizzaFactoryDefinition)
    {
        _pizzaFactoryDefinition = [TyphoonFactoryProvider withProtocol:[self pizzaFactoryProtocol] dependencies:^(TyphoonDefinition *definition) {
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

- (TyphoonDefinition *)paymentFactoryBlocksDefinition
{
    if (!_paymentFactoryDefinition)
    {
        _paymentFactoryDefinition = [TyphoonFactoryProvider withProtocol:[self paymentFactoryProtocol] dependencies:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(creditService) withObjectInstance:_creditService];
            [definition injectProperty:@selector(authService) withObjectInstance:_authService];
        } factory:^id (id<PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
            return [[PaymentImpl alloc] initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
        }];
    }

    return _paymentFactoryDefinition;
}

- (TyphoonDefinition *)paymentFactoryInitializersDefinition
{
    if (!_paymentFactoryDefinition)
    {
        _paymentFactoryDefinition = [TyphoonFactoryProvider withProtocol:[self paymentFactoryProtocol] dependencies:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(creditService) withObjectInstance:_creditService];
            [definition injectProperty:@selector(authService) withObjectInstance:_authService];
        } factories:^(TyphoonAssistedFactoryDefinition *definition) {
            [definition factoryMethod:@selector(paymentWithStartDate:amount:) returns:[PaymentImpl class] initialization:^(TyphoonAssistedFactoryMethodInitializer *initializer) {
                initializer.selector = @selector(initWithCreditService:authService:startDate:amount:);
                [initializer injectWithProperty:@selector(creditService)];
                [initializer injectWithProperty:@selector(authService)];
                [initializer injectWithArgumentNamed:@"startDate"];
                [initializer injectWithArgumentNamed:@"amount"];
            }];
        }];
    }

    return _paymentFactoryDefinition;
}


- (void)test_factory_definition_should_be_right_class
{
    Class klass = [self pizzaFactoryDefinition].type;

    assertThatBool(class_conformsToProtocol(klass, [self pizzaFactoryProtocol]), is(equalToBool(YES)));

    Class superklass = class_getSuperclass(klass);
    assertThat(superklass, is([TyphoonAssistedFactoryBase class]));
}

- (void)test_factory_definition_should_have_injected_properties
{
    NSSet *injectedProperties = [self paymentFactoryBlocksDefinition].injectedProperties;

    NSMutableArray *injectedPropertyNames = [NSMutableArray array];
    [injectedProperties enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [injectedPropertyNames addObject:[obj name]];
    }];

    assertThat(injectedPropertyNames, hasCountOf(2));
    assertThat(injectedPropertyNames, hasItems(equalTo(@"creditService"), equalTo(@"authService"), nil));
}

- (void)test_factory_should_respond_to_properties
{
    Class klass = [self paymentFactoryBlocksDefinition].type;
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
    Class klass = [self paymentFactoryBlocksDefinition].type;
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

- (void)test_factory_should_invoke_correct_initializers
{
    Class klass = [self paymentFactoryInitializersDefinition].type;
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
