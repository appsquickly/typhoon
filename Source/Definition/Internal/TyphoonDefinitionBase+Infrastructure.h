////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonDefinitionBase.h"

@class TyphoonRuntimeArguments;

@interface TyphoonDefinitionBase ()

/**
 * The key of the component. A key is useful when multiple configuration of the same class or protocol are desired - for example
 * MasterCardPaymentClient and VisaPaymentClient.
 *
 * If using the TyphoonBlockComponentFactory style of assembly, the key is automatically generated based on the selector name of the
 * component, thus avoiding "magic strings" and providing better integration with IDE refactoring tools.
 */
@property (nonatomic) NSString *key;

// TODO: doc
@property (nonatomic) TyphoonRuntimeArguments *currentRuntimeArguments;

/** 
 * This flag used to distinguish definitions from reference to them. First time, when definition created, processed flag set to NO,
 * but next time, when this definition returned by reference (shortcut with another runtime args) processed flag will be set to YES.
 */
@property (nonatomic) BOOL processed;

// TODO: doc
@property (nonatomic, readonly, getter = isScopeSetByUser) BOOL scopeSetByUser;


- (instancetype)initWithClass:(Class)clazz key:(NSString *)key;

@end


@interface TyphoonDefinitionBase (Infrastructure)

+ (instancetype)withClass:(Class)clazz key:(NSString *)key;

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses;

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol;

@end
