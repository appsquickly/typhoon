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

@implementation PaymentFactoryAssembly

- (id)authService
{
    return [TyphoonDefinition withClass:[AuthServiceImpl class]];
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

@end
