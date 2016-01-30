////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonDefinitionBase.h"

@class TyphoonRuntimeArguments;

@interface TyphoonDefinitionBase ()

// TODO: doc
@property (nonatomic) TyphoonRuntimeArguments *currentRuntimeArguments;

/**
 * This flag used to distinguish definitions from reference to them. First time, when definition created, processed flag set to NO,
 * but next time, when this definition returned by reference (shortcut with another runtime args) processed flag will be set to YES.
 */
@property (nonatomic) BOOL processed;

// TODO: doc
@property (nonatomic, readonly, getter = isScopeSetByUser) BOOL scopeSetByUser;

// TODO: doc ("see TyphoonDefinitionBase+Infrastructure")
@property (nonatomic) NSString *key;

- (instancetype)initWithClass:(Class)clazz key:(NSString *)key;

@end
