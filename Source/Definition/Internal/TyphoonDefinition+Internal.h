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

@property (nonatomic) TyphoonRuntimeArguments *currentRuntimeArguments;

/**
 * This flag used to distinguish definitions from reference to them. First time, when definition created, processed flag set to NO,
 * but next time, when this definition returned by reference (shortcut with another runtime args) processed flag will be set to YES.
 */
@property (nonatomic) BOOL processed;

/**
 * This flag indicated where the scope was changed manually by the user.
 */
@property (nonatomic, readonly, getter = isScopeSetByUser) BOOL scopeSetByUser;

/**
 * An assembly from which this definition was built. 
 * The property must be weak to prevent a retain cycle between factory, definition and assembly.
 */
@property (nonatomic, weak) TyphoonAssembly *assembly;

/**
 * An assembly selector this definition has originated from.
 */
@property (nonatomic, assign) SEL assemblySelector;

@end
