//
//  TyphoonInjectionByFactoryReference.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"
#import "TyphoonInjectionByReference.h"

@interface TyphoonInjectionByFactoryReference : TyphoonInjectionByReference

@property(nonatomic, readonly) NSString *keyPath;

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments keyPath:(NSString *)keyPath;

@end
