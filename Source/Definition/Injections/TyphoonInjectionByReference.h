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

@interface TyphoonInjectionByReference : TyphoonAbstractInjection

@property(nonatomic, strong, readonly) NSString *reference;
@property(nonatomic, strong, readonly) TyphoonRuntimeArguments *referenceArguments;

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments;

- (void)resolveCircularDependencyWithContext:(TyphoonInjectionContext *)context block:(dispatch_block_t)block;
- (id)resolveReferenceWithContext:(TyphoonInjectionContext *)context;

@end
