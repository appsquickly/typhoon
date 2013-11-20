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

@interface TyphoonAssistedFactoryParameterInjectedWithProperty : NSObject <TyphoonAssistedFactoryInjectedParameter>

@property (nonatomic, assign, readonly) NSUInteger parameterIndex;
@property (nonatomic, assign, readonly) SEL property;

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex property:(SEL)property;

@end
