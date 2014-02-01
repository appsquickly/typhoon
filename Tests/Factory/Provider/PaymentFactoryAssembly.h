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


#import "Typhoon.h"

@interface PaymentFactoryAssembly : TyphoonAssembly

- (id)authService;

- (id)creditService;

- (id)paymentFactory;

- (id)pizzaFactory;

@end
