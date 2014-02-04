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

#import "TyphoonAssistedFactoryInjectedParameter.h"

/**
 * Describes a parameter injected with a factory property.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryParameterInjectedWithProperty : NSObject <TyphoonAssistedFactoryInjectedParameter>

/** The parameter index */
@property(nonatomic, assign, readonly) NSUInteger parameterIndex;

/** The property name */
@property(nonatomic, assign, readonly) SEL property;

/** Creates a parameter description for the given parameterIndex and property */
- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex property:(SEL)property;

@end
