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

#import "TyphoonFactoryProvider.h"

#import <SenTestingKit/SenTestingKit.h>
#import <objc/runtime.h>

#import "TyphoonFactoryProviderTestHelper.h"

#import "AuthServiceImpl.h"
#import "CreditServiceImpl.h"
#import "TyphoonAssistedFactoryBase.h"
#import "TyphoonDefinition.h"
#import "PaymentFactory.h"
#import "PaymentFactoryAssembly.h"
#import "PaymentImpl.h"


@interface TyphoonFactoryProviderTest : SenTestCase
@end

@implementation TyphoonFactoryProviderTest
{
    Protocol *_paymentFactoryProtocol;
    TyphoonDefinition *_paymentFactoryDefinition;

    id <CreditService> _creditService;
    id <AuthService> _authService;
}

- (void)setUp
{
    _creditService = (id <CreditService>) [[NSObject alloc] init];
    _authService = (id <AuthService>) [[NSObject alloc] init];
}

- (Protocol *)paymentFactoryProtocol
{
    if (!_paymentFactoryProtocol) {
        _paymentFactoryProtocol = protocol_clone(@protocol(PaymentFactory));
    }

    return _paymentFactoryProtocol;
}

- (TyphoonDefinition *)paymentFactoryBlocksDefinition
{
    if (!_paymentFactoryDefinition) {
        _paymentFactoryDefinition =
            [TyphoonFactoryProvider withProtocol:[self paymentFactoryProtocol] dependencies:^(TyphoonDefinition *definition) {
                [definition injectProperty:@selector(creditService) with:_creditService];
                [definition injectProperty:@selector(authService) with:_authService];
            } factory:^id(id <PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
                return [[PaymentImpl alloc]
                    initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
            }];
    }

    return _paymentFactoryDefinition;
}

- (TyphoonDefinition *)paymentFactoryInitializerDefinition
{
    if (!_paymentFactoryDefinition) {
        _paymentFactoryDefinition =
            [TyphoonFactoryProvider withProtocol:[self paymentFactoryProtocol] dependencies:^(TyphoonDefinition *definition) {
                [definition injectProperty:@selector(creditService) with:_creditService];
                [definition injectProperty:@selector(authService) with:_authService];
            } factories:^(TyphoonAssistedFactoryDefinition *definition) {
                [definition factoryMethod:@selector(paymentWithStartDate:amount:) returns:[PaymentImpl class]
                    initialization:^(TyphoonAssistedFactoryMethodInitializer *initializer) {
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


- (void)test_block_factory_definition_should_be_right_class
{
    Class klass = [self paymentFactoryBlocksDefinition].type;

    assertThatBool(class_conformsToProtocol(klass, [self paymentFactoryProtocol]), is(equalToBool(YES)));

    Class superklass = class_getSuperclass(klass);
    assertThat(superklass, is([TyphoonAssistedFactoryBase class]));
}

- (void)test_block_factory_definition_should_have_injected_properties
{
    NSSet *injectedProperties = [self paymentFactoryBlocksDefinition].injectedProperties;

    NSMutableArray *injectedPropertyNames = [NSMutableArray array];
    [injectedProperties enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [injectedPropertyNames addObject:[obj propertyName]];
    }];

    assertThat(injectedPropertyNames, hasCountOf(2));
    assertThat(injectedPropertyNames, hasItems(equalTo(@"creditService"), equalTo(@"authService"), nil));
}


- (void)test_initializer_factory_definition_should_be_right_class
{
    Class klass = [self paymentFactoryInitializerDefinition].type;

    assertThatBool(class_conformsToProtocol(klass, [self paymentFactoryProtocol]), is(equalToBool(YES)));

    Class superklass = class_getSuperclass(klass);
    assertThat(superklass, is([TyphoonAssistedFactoryBase class]));
}

- (void)test_initializer_factory_definition_should_have_injected_properties
{
    NSSet *injectedProperties = [self paymentFactoryInitializerDefinition].injectedProperties;

    NSMutableArray *injectedPropertyNames = [NSMutableArray array];
    [injectedProperties enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [injectedPropertyNames addObject:[obj propertyName]];
    }];

    assertThat(injectedPropertyNames, hasCountOf(2));
    assertThat(injectedPropertyNames, hasItems(equalTo(@"creditService"), equalTo(@"authService"), nil));
}

@end
