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

@interface TyphoonAssistedFactoryParameterInjectedWithArgumentIndex : NSObject <TyphoonAssistedFactoryInjectedParameter>

@property (nonatomic, assign, readonly) NSUInteger parameterIndex;
@property (nonatomic, assign, readonly) NSUInteger argumentIndex;

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex argumentIndex:(NSUInteger)argumentIndex;

@end
