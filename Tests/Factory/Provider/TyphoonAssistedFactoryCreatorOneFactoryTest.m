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

#import "TyphoonAssistedFactoryCreatorOneFactory.h"

#import <SenTestingKit/SenTestingKit.h>
#include <objc/runtime.h>

#import "TyphoonFactoryProviderTestHelper.h"

#import "AuthService.h"
#import "CreditService.h"
#import "PaymentFactory.h"
#import "PaymentImpl.h"
#import "TyphoonAssistedFactoryBase.h"
#import "TyphoonDefinition.h"


@interface TyphoonAssistedFactoryCreatorOneFactoryTest : SenTestCase
@end

@implementation TyphoonAssistedFactoryCreatorOneFactoryTest {
    Protocol *_paymentFactoryProtocol;
    Class _paymentFactoryClass;

    id <CreditService> _creditService;
    id <AuthService> _authService;
}

- (void)setUp {
    _creditService = (id <CreditService>) [[NSObject alloc] init];
    _authService = (id <AuthService>) [[NSObject alloc] init];
}

- (Protocol *)paymentFactoryProtocol {
    if (!_paymentFactoryProtocol) {
        _paymentFactoryProtocol = protocol_clone(@protocol(PaymentFactory));
    }

    return _paymentFactoryProtocol;
}

- (Class)paymentFactoryClass {
    if (!_paymentFactoryClass) {
        _paymentFactoryClass = [[[TyphoonAssistedFactoryCreatorOneFactory alloc] initWithProtocol:[self paymentFactoryProtocol]
            factoryBlock:^id(id <PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
                return [[PaymentImpl alloc]
                    initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
            }] factoryClass];
    }

    return _paymentFactoryClass;
}

- (void)test_factory_class_should_implement_protocol {
    Class klass = [self paymentFactoryClass];

    assertThatBool(class_conformsToProtocol(klass, [self paymentFactoryProtocol]), is(equalToBool(YES)));

    Class superklass = class_getSuperclass(klass);
    assertThat(superklass, is([TyphoonAssistedFactoryBase class]));
}

- (void)test_factory_should_respond_to_properties {
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    assertThatBool([factory respondsToSelector:@selector(creditService)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(authService)], is(equalToBool(YES)));
}

- (void)test_factory_should_implement_properties {
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    [(NSObject *) factory setValue:_creditService forKey:@"creditService"];
    [(NSObject *) factory setValue:_authService forKey:@"authService"];
    assertThat(factory.creditService, is(_creditService));
    assertThat(factory.authService, is(_authService));
}

- (void)test_factory_should_invoke_correct_method_blocks {
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    [(NSObject *) factory setValue:_creditService forKey:@"creditService"];
    [(NSObject *) factory setValue:_authService forKey:@"authService"];

    NSDate *now = [NSDate date];
    id <Payment> payment = [factory paymentWithStartDate:now amount:456];

    assertThat(payment.creditService, is(_creditService));
    assertThat(payment.authService, is(_authService));
    assertThat(payment.startDate, is(now));
    assertThatInteger(payment.amount, is(equalToInteger(456)));
}

@end
