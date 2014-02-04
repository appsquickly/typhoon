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
 * Describes a parameter injected from a factory method argument.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryParameterInjectedWithArgumentIndex : NSObject <TyphoonAssistedFactoryInjectedParameter>

/** The parameter index */
@property(nonatomic, assign, readonly) NSUInteger parameterIndex;

/** The factory method argument index */
@property(nonatomic, assign, readonly) NSUInteger argumentIndex;

/** Creates a parameter description from the given parameterIndex and argumentIndex */
- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex argumentIndex:(NSUInteger)argumentIndex;

@end
