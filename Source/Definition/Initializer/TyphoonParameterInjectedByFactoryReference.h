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
#import "TyphoonAbstractInjectedParameter.h"

/**
*/
@interface TyphoonParameterInjectedByFactoryReference : TyphoonAbstractInjectedParameter

@property(nonatomic, strong, readonly) NSString *factoryReference;
@property(nonatomic, strong, readonly) NSString *keyPath;

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex factoryReference:(NSString *)reference keyPath:(NSString *)keyPath;

@end
