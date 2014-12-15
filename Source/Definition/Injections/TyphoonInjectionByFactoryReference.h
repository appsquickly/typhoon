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
#import "TyphoonInjectionByReference.h"

@interface TyphoonInjectionByFactoryReference : TyphoonInjectionByReference

@property(nonatomic, readonly) NSString *keyPath;

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments keyPath:(NSString *)keyPath;

@end
