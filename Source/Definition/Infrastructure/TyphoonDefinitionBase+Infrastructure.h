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

@interface TyphoonDefinitionBase (Infrastructure)

/**
 * The key of the component. A key is useful when multiple configuration of the same class or protocol are desired - for example
 * MasterCardPaymentClient and VisaPaymentClient.
 *
 * If using the TyphoonBlockComponentFactory style of assembly, the key is automatically generated based on the selector name of the
 * component, thus avoiding "magic strings" and providing better integration with IDE refactoring tools.
 */
@property (nonatomic) NSString *key;

+ (instancetype)withClass:(Class)clazz key:(NSString *)key;

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses;

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol;

@end
