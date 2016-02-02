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


#import "TyphoonDefinition.h"

@class TyphoonMethod;
@class TyphoonRuntimeArguments;
@class TyphoonAssembly;

@interface TyphoonDefinition ()

// TODO: doc
@property (nonatomic) TyphoonRuntimeArguments *currentRuntimeArguments;

/**
 * This flag used to distinguish definitions from reference to them. First time, when definition created, processed flag set to NO,
 * but next time, when this definition returned by reference (shortcut with another runtime args) processed flag will be set to YES.
 */
@property (nonatomic) BOOL processed;

// TODO: doc
@property (nonatomic, readonly, getter = isScopeSetByUser) BOOL scopeSetByUser;

// TODO: doc ("see TyphoonDefinition+Infrastructure")
@property (nonatomic) NSString *key;

// This must be weak to prevent retain cycle between factory, definition and assembly.
@property (nonatomic, weak) TyphoonAssembly *assembly;

@property (nonatomic, assign) SEL assemblySelector;

@property (nonatomic, readonly) TyphoonMethod *initializer;

@property (nonatomic, getter = isInitializerGenerated) BOOL initializerGenerated;

- (instancetype)initWithClass:(Class)clazz key:(NSString *)key;

@end
