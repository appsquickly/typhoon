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

#import <XCTest/XCTest.h>
#include <objc/runtime.h>

#import "TyphoonFactoryProviderTestHelper.h"

#import "AuthService.h"
#import "CreditService.h"
#import "PaymentFactory.h"
#import "PaymentImpl.h"
#import "TyphoonAssistedFactoryBase.h"
#import "TyphoonDefinition.h"


@interface TyphoonAssistedFactoryCreatorOneFactoryTest : XCTestCase
@end

@implementation TyphoonAssistedFactoryCreatorOneFactoryTest
{
    Protocol *_paymentFactoryProtocol;
    Class _paymentFactoryClass;

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

- (Class)paymentFactoryClass
{
    if (!_paymentFactoryClass) {
        _paymentFactoryClass = [[[TyphoonAssistedFactoryCreatorOneFactory alloc] initWithProtocol:[self paymentFactoryProtocol]
            factoryBlock:^id(id <PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
                return [[PaymentImpl alloc]
                    initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
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

- (void)test_factory_should_invoke_correct_method_blocks
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
