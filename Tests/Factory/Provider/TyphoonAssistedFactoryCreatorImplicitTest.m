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

#import "TyphoonAssistedFactoryCreatorImplicit.h"

#import <SenTestingKit/SenTestingKit.h>
#include <objc/runtime.h>

#import "TyphoonFactoryProviderTestHelper.h"

#import "AuthService.h"
#import "CreditService.h"
#import "PaymentFactory.h"
#import "PaymentImpl.h"
#import "Person.h"
#import "PersonFactory.h"
#import "TyphoonAbstractInjectedProperty.h"
#import "TyphoonAssistedFactoryBase.h"
#import "TyphoonDefinition.h"


@interface TyphoonAssistedFactoryCreatorImplicitTest : SenTestCase
@end

@implementation TyphoonAssistedFactoryCreatorImplicitTest
{
    Protocol *_paymentFactoryProtocol;
    Class _paymentFactoryClass;

    id <CreditService> _creditService;
    id <AuthService> _authService;

    Protocol *_personFactoryProtocol;
    Class _personFactoryClass;
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

- (Class)paymentFactoryClass
{
    if (!_paymentFactoryClass) {
        _paymentFactoryClass =
            [[[TyphoonAssistedFactoryCreatorImplicit alloc] initWithProtocol:[self paymentFactoryProtocol] returns:[PaymentImpl class]]
                factoryClass];
    }

    return _paymentFactoryClass;
}

- (Protocol *)personFactoryProtocol
{
    if (!_personFactoryProtocol) {
        _personFactoryProtocol = protocol_clone(@protocol(PersonFactory));
    }

    return _personFactoryProtocol;
}

- (Class)personFactoryClass
{
    if (!_personFactoryClass) {
        _personFactoryClass =
            [[[TyphoonAssistedFactoryCreatorImplicit alloc] initWithProtocol:[self personFactoryProtocol] returns:[Person class]]
                factoryClass];
    }

    return _personFactoryClass;
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
    id <PaymentFactory> factory = [[klass alloc] init];

    assertThatBool([factory respondsToSelector:@selector(creditService)], is(equalToBool(YES)));
    assertThatBool([factory respondsToSelector:@selector(authService)], is(equalToBool(YES)));
}

- (void)test_factory_should_implement_properties
{
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    id mockCreditServiceInjectedProperty = mock([TyphoonAbstractInjectedProperty class]);
    [given([mockCreditServiceInjectedProperty name]) willReturn:@"creditService"];

    id mockAuthServiceInjectedProperty = mock([TyphoonAbstractInjectedProperty class]);
    [given([mockAuthServiceInjectedProperty name]) willReturn:@"authService"];

    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockCreditServiceInjectedProperty withType:nil lazyValue:^{ return _creditService; }];
    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockAuthServiceInjectedProperty withType:nil lazyValue:^{ return _authService; }];

    assertThat(factory.creditService, is(_creditService));
    assertThat(factory.authService, is(_authService));
}

- (void)test_factory_should_invoke_correct_initializers
{
    Class klass = [self paymentFactoryClass];
    id <PaymentFactory> factory = [[klass alloc] init];

    id mockCreditServiceInjectedProperty = mock([TyphoonAbstractInjectedProperty class]);
    [given([mockCreditServiceInjectedProperty name]) willReturn:@"creditService"];

    id mockAuthServiceInjectedProperty = mock([TyphoonAbstractInjectedProperty class]);
    [given([mockAuthServiceInjectedProperty name]) willReturn:@"authService"];

    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockCreditServiceInjectedProperty withType:nil lazyValue:^{ return _creditService; }];
    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockAuthServiceInjectedProperty withType:nil lazyValue:^{ return _authService; }];

    NSDate *now = [NSDate date];
    id <Payment> payment = [factory paymentWithStartDate:now amount:456];

    assertThat(payment.creditService, is(_creditService));
    assertThat(payment.authService, is(_authService));
    assertThat(payment.startDate, is(now));
    assertThatInteger(payment.amount, is(equalToInteger(456)));
}

- (void)test_multi_factory_should_invoke_correct_initializers
{
    Class klass = [self personFactoryClass];
    id <PersonFactory> factory = [[klass alloc] init];

    id mockCreditServiceInjectedProperty = mock([TyphoonAbstractInjectedProperty class]);
    [given([mockCreditServiceInjectedProperty name]) willReturn:@"creditService"];

    id mockAuthServiceInjectedProperty = mock([TyphoonAbstractInjectedProperty class]);
    [given([mockAuthServiceInjectedProperty name]) willReturn:@"authService"];

    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockCreditServiceInjectedProperty withType:nil lazyValue:^{ return _creditService; }];
    [(id<TyphoonPropertyInjectionInternalDelegate>) factory shouldInjectProperty:mockAuthServiceInjectedProperty withType:nil lazyValue:^{ return _authService; }];

    Person *p1 = [factory personWithFirstName:@"foo" lastName:@"bar"];
    assertThatBool(p1.usedInitializer == @selector(initWithCreditService:authService:firstName:lastName:), is(equalToBool(YES)));

    Person *p2 = [factory personWithFirstName:@"foo"];
    assertThatBool(p2.usedInitializer == @selector(initWithCreditService:authService:firstName:), is(equalToBool(YES)));

    Person *p3 = [factory personWithLastName:@"foo" authService:_authService];
    assertThatBool(p3.usedInitializer == @selector(initWithCreditService:authService:lastName:), is(equalToBool(YES)));

    Person *p4 = [factory personWithLastName:@"foo"];
    assertThatBool(p4.usedInitializer == @selector(initWithCreditService:lastName:), is(equalToBool(YES)));
}

@end
