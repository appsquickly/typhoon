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

#import <Foundation/Foundation.h>

@protocol TyphoonAssistedFactoryMethodClosure <NSObject>

@property(nonatomic, strong, readonly) NSMethodSignature *methodSignature;

/**
 * Returns an invocation filled with the right target instance, the right
 * selector and the arguments according to the specifics of one of the types
 * following this protocol. For blocks, this method will simply copy the
 * forwardedInvocation arguments into the new invocation, for initializers, the
 * type will take the initializer parameters, using factory to find the property
 * values, and forwardedInvocation to find the arguments to the factory method.
 */
- (NSInvocation *)invocationWithFactory:(id)factory forwardedInvocation:(NSInvocation *)anInvocation;

@end
