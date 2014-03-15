//
//  TyphoonInjectionByReference.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"

@interface TyphoonInjectionByReference : TyphoonAbstractInjection

@property(nonatomic, strong, readonly) NSString *reference;
@property(nonatomic, strong, readonly) TyphoonRuntimeArguments *referenceArguments;

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments;

- (id)componentForReferenceWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)runtimeArgs;

@end
