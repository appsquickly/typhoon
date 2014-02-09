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


#import "TyphoonPropertyInjectedByReference.h"

@interface TyphoonPropertyInjectedByFactoryReference : TyphoonPropertyInjectedByReference

@property(nonatomic, readonly) NSString *keyPath;

- (instancetype)initWithName:(NSString *)name reference:(NSString *)reference keyPath:(NSString *)keyPath;


@end
