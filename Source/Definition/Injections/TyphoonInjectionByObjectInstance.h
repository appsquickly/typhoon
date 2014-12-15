////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonAbstractInjection.h"

@interface TyphoonInjectionByObjectInstance : TyphoonAbstractInjection

@property(nonatomic, strong, readonly) id objectInstance;

- (instancetype)initWithObjectInstance:(id)objectInstance;

@end
