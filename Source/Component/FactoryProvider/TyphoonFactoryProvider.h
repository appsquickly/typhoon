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

#import <Foundation/Foundation.h>

#import "TyphoonDefinition.h"
#import "TyphoonAssistedFactoryDefinition.h"

/**
* Provides a factory that combines the convenience method arguments with the
* assembly-supplied dependencies to construct objects.
*
* To create a factory you must define a protocol for the factory, wire its
* dependencies (defined as readonly properties), and provide implementation
* blocks for the body of the class methods. It is not as automatic as we will
* like, but at least it avoids a lot of tedius and repetitive boilerplate.
*
* # Example
*
* Imagine you have defined this Payment class with two dependencies that should
* be injected, and two parameters that must be provided at runtime.
*
* 	@interface Payment : NSObject
* 	
* 	- (instancetype)initWithCreditService:(id<CreditService>)creditService
* 	                          authService:(id<AuthService>)authService
* 	                            startDate:(NSDate *)date
* 	                                amout:(NSUInteger)amount;
* 	
* 	@end
*
* You also define a protocol for the factory of the Payment objects. The factory
* must declare the dependencies as readonly properties, and the factory methods
* should be the only ones existing.
*
* 	@protocol PaymentFactory <NSObject>
* 	
* 	@property (nonatomic, strong, readonly) id<CreditService> creditService;
* 	@property (nonatomic, strong, readonly) id<AuthService> authService;
* 	
* 	+ (Payment *)paymentWithStartDate:(NSDate *)startDate
* 	                           amount:(NSUInteger)amount;
* 	
* 	@end
*
* Then, in your assembly file, you define the PaymentFactory component using the
* TyphoonFactoryProvider as the following code:
*
* 	- (id)paymentFactory {
* 	  return [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition) {
* 	    [definition injectProperty:@selector(creditService)];
* 	    [definition injectProperty:@selector(authService)];
* 	  } factories:^(TyphoonAssistedFactoryDefinition *definition) {
* 	    [definition factoryMethod:@selector(paymentWithStartDate:amount:) body:^id (id<PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
* 	      return [[Payment alloc] initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
* 	    }];
* 	  }];
* 	}
*
* In the dependencies block you can use any `injectProperty:` method that you
* will use for your normal definitions. It is a standard TyphoonDefinitionBlock
* that get passed directly to the TyphoonDefinition constructor used internally.
*
* For the factories block you must provide one body block for each class method
* of your factory protocol. The block used as the body receives the factory
* itself as the first argument, so you can use the factory properties, and then
* the rest of the class method arguments in the second and following positions.
*
* In the case of the protocol having only one factory method you can use a
* shorter version of the method. For example the equivalent shorter version for
* the above definition will be the following one:
*
* 	- (id)paymentFactory {
* 	  return [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition) {
* 	    [definition injectProperty:@selector(creditService)];
* 	    [definition injectProperty:@selector(authService)];
* 	  } factory^id (id<PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
* 	    return [[Payment alloc] initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
* 	  }];
* 	}
*
* Know limitation: You can only create one factory for a given protocol.
*/
@interface TyphoonFactoryProvider : NSObject

/**
* Creates a factory definition for a given protocol, dependencies and factory
* block. The protocol is supposed to only have one class method, otherwise this
* method will fail during runtime.
*/
+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol
                       dependencies:(TyphoonDefinitionBlock)dependenciesBlock
                            factory:(id)factoryBlock;

/**
 * Creates a factor definition for a given protocol, dependencies and a list of
 * factory methods. The protocol is supposed to have the same number of class
 * methods, and with the same selectors as defined in the factories block,
 * otherwise this method will fail during runtime.
 */
+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol
                       dependencies:(TyphoonDefinitionBlock)dependenciesBlock
                          factories:(TyphoonAssistedFactoryDefinitionBlock)definitionBlock;

@end
