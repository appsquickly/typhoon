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
* @ingroup Factory
*
* Provides a factory that combines the convenience of method arguments with assembly-supplied dependencies to construct objects.
*
* To create a factory you must define a protocol for the factory, wire its dependencies (defined as readonly properties), and, sometimes,
* provide implementation blocks or initializer descriptions for the body of the class methods. Most of the simplest cases should be covered
* with no glue code, and the rest of them, with a couple of lines.
*
* ## Example
*
*  Imagine you have defined this Payment class with two dependencies that should
*  be injected, and two parameters that must be provided at runtime.
*
* @code
@interface Payment : NSObject

- (instancetype)initWithCreditService:(id<CreditService>)creditService authService:(id<AuthService>)authService startDate:(NSDate *)date
   amount:(NSUInteger)amount;

@end
@endcode
*
*  You also define a protocol for the factory of the Payment objects. The factory
*  must declare the dependencies as readonly properties, and the factory methods
*  should be the only ones existing.
*
* @code
@protocol PaymentFactory <NSObject>

@property (nonatomic, strong, readonly) id<CreditService> creditService;
@property (nonatomic, strong, readonly) id<AuthService> authService;

+ (Payment *)paymentWithStartDate:(NSDate *)startDate amount:(NSUInteger)amount;

@end
@endcode
*
*  (It is very important that your properties, which will normally be the
*  dependencies, are readonly. Do not worry, Typhoon will be able to inject their
*  values just fine).
*
*  Then, in your assembly file, you define the PaymentFactory component using the
*  TyphoonFactoryProvider as the following code:
*
* @code

- (id)paymentFactory {
  return [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition)
  {
    [definition injectProperty:@selector(creditService)];
    [definition injectProperty:@selector(authService)];
  } returns:[Payment class]];
}

@endcode
*
* The factory provider will create a new class during runtime to implement the
* protocol, and create the implementation of the protocol method looking for
* a good init method in the return type.
*
* In the dependencies block you can use any `injectProperty:` method that you
* will use for your normal definitions. It is a standard TyphoonDefinitionBlock
* that get passed directly to the TyphoonDefinition constructor used internally.
*
* Sometimes you might need to customize which init method gets used in the
* factory method, since the heuristic might not work for your classes, or you
* cannot modify the return type method names. In those cases, you can always
* provide your own implementation, and make the call to the init method
* yourself:
*
* @code

- (id)paymentFactory
{
  return [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition)
  {
    [definition injectProperty:@selector(creditService)];
    [definition injectProperty:@selector(authService)];
  } factories:^(TyphoonAssistedFactoryDefinition *definition) {
    [definition factoryMethod:@selector(paymentWithStartDate:amount:) body:^id (id<PaymentFactory> factory, NSDate *startDate, NSUInteger amount) {
      return [[Payment alloc] initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
    }];
  }];
}

@endcode
*
* For the factories block you must provide one body block for each class method
* of your factory protocol. The block used as the body receives the factory
* itself as the first argument, so you can use the factory properties, and then
* the rest of the class method arguments in the second and following positions.
*
* You can use `withProtocol:dependencies:factories:` method also when your
* protocol has several factory methods, providing one body for each of them.
*
* In the case of the protocol having only one factory method you can use a
* shorter version of the method. For example the equivalent shorter version for
* the above definition will be the following one:
*
* @code

- (id)paymentFactory
{
  return [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition)
  {
    [definition injectProperty:@selector(creditService)];
    [definition injectProperty:@selector(authService)];
  } factory:^id (id<PaymentFactory> factory, NSDate *startDate, NSUInteger amount)
  {
    return [[Payment alloc] initWithCreditService:factory.creditService authService:factory.authService startDate:startDate amount:amount];
  }];
}

@endcode
*
* There is an alternative way to define the factory methods, but since it
* involves writing a lot more code than the blocks used above, it is not
* recommended. For the example above the code will be the following:
*
* @code

- (id)paymentFactory
{
  return [TyphoonFactoryProvider withProtocol:@protocol(PaymentFactory) dependencies:^(TyphoonDefinition *definition)
  {
    [definition injectProperty:@selector(creditService)];
    [definition injectProperty:@selector(authService)];
  } factories:^(TyphoonAssistedFactoryDefinition *definition)
  {
    [definition factoryMethod:@selector(paymentWithStartDate:amount:) returns:[Payment class]
            initialization:^(TyphoonAssistedFactoryMethodInitializer *initializer) {
        [initializer setSelector:@selector(initWithCreditService:authService:startDate:amount:)];
        [initializer injectWithProperty:@selector(creditService)];
        [initializer injectWithProperty:@selector(authService)];
        [initializer injectWithArgumentNamed:@"startDate"];
        [initializer injectWithArgumentNamed:@"amount"];
    }];
  }];
}
@endcode
*
*
* You can also use `injectWithArgumentAtIndex:` if you prefer to refer to the
* factory method argument position.
*
*
* Known limitation: You can only create one factory for a given protocol.
*/
@interface TyphoonFactoryProvider : NSObject

/**
 * Creates a factory definition for a given protocol, dependencies and factory block. The protocol is supposed to only have one factory
 * method, otherwise this method will fail during runtime.
*/
+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock factory:(id)factoryBlock;

/**
 * Creates a factory definition for a given protocol, dependencies, and return type. The protocol can have any number of instance
 * methods, but each one should match one of the initializers.
 *
 * The factory method will invoke one of the initializer methods of the returnType. To determine which initializer method will be used, the
 * atoms of the factory method and the init method will be matched, filling up missing parameters with the properties present in the
 * protocol. Ties will be resolved choosing the init method with most factory method arguments used. This scoring system will also be used
 * in case two factory methods can be used with one initializer: the one with highest number of arguments and less properties will match
 * the initializer, and the other one will need to match another initializer. If no valid init method is found, the invocation
 * will fail during runtime.
 *
 * For this method to work the names of the factory methods and the init method should follow some common rules:
 *
 * - The init method name should start with `initWith`.
 * - The factory method name should have `With` between the return type and the argument "names".
 * - All argument "names" are transformed to be "camelCase" (first letter will always be lowercase).
 * - Property names should be "camelCase".
 * - No "and" between argument "names".
 *
 * Initializers and factory methods like the following follow the rules:
 *
 * - initWithName:, initWithName:age:gender:, initWithDate:amount:
 * - personWithName:, personWithName:age:gender:, paymentWithDate:amount:
 *
 * While names like the following will not work:
 *
 * - initFromFile:, initWithX:andY:
 * - personNamed:age:gender:
 *
 * If your init method or your factory method could not follow the rules (or you don't want them to follow the rules) you should use one of
 * the other methods of this class and provide the implementation block yourself.
 *
 * Typhoon will try to match as good as it can the init method with the factory methods, but sometimes the automatic matching might fail, or
 * might not provide the desidered pair. Again, you are free to use any other method from this class and perform the matching manually. If
 * you want to debug the matching performed by Typhoon, enable LOGGING_LEVEL_TRACE in your build, and look in your console output for lines
 * like "Factory Provider: found candidate: [YourProtocol yourFactoryMethodWithFoo:] --> [YourReturnType initWithFoo:]".
 */
+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock returns:(Class)returnType;

/**
 * Creates a factor definition for a given protocol, dependencies and a list of factory methods. The protocol is supposed to have the same
 * number of class methods, and with the same selectors as defined in the factories block, otherwise this method will fail during runtime.
*/
+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock
    factories:(TyphoonAssistedFactoryDefinitionBlock)definitionBlock;

@end
