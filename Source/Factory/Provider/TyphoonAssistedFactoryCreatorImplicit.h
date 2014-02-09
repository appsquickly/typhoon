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

#import "TyphoonAssistedFactoryCreator.h"

/**
 * Creates the full factory class from the given protocol description. The
 * protocol instance methods should match one of the initializers of the
 * returnType. See the documentation of TyphoonFactoryProvider for the rules
 * used to do this matching.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryCreatorImplicit : TyphoonAssistedFactoryCreator

/**
 * Creates a factory creator for the given protocol. It will guess the protocol
 * instance method to use, and also the initializer in returnType, as well as
 * the mapping between the factory method arguments, factory properties and
 * init method arguments.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol returns:(Class)returnType;

@end
