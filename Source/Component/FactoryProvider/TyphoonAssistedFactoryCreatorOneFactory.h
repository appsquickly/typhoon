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
 * protocol should only have one instance method. The given factoryBlock will
 * be used as its implementation.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryCreatorOneFactory : TyphoonAssistedFactoryCreator

/**
 * Creates a given factory creator for the given protocol and using factoryBlock
 * as the implementation of the only instance method of the protocol.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol factoryBlock:(id)factoryBlock;

@end
