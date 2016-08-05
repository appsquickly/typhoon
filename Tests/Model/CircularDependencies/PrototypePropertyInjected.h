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

#import <Foundation/Foundation.h>

@class PrototypeInitInjected;

@interface PrototypePropertyInjected : NSObject

@property(nonatomic, strong) PrototypeInitInjected *prototypeInitInjected;

@property (nonatomic, strong) PrototypePropertyInjected *propertyA;
@property (nonatomic, strong) PrototypePropertyInjected *propertyB;
@property (nonatomic, strong) PrototypePropertyInjected *propertyC;

- (void)checkThatPropertyAHasPropertyBandC;

@end
