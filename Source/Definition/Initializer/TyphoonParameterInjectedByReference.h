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
@interface TyphoonParameterInjectedByReference : TyphoonAbstractInjectedParameter

@property(nonatomic, strong, readonly) NSString *reference;

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex reference:(NSString *)reference;


@end
