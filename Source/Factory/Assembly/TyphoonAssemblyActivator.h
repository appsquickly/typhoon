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

#import <Foundation/Foundation.h>

@class TyphoonAssembly;

__attribute__ ((deprecated))

/**
* Activates an assembly. Prior to activation the assembly interface returns TyphoonDefinitions. After activation
* assembly interface poses in of a TyphoonComponentFactory to return built instances.
*
* This class is deprecated, use the TyphoonAssembly#activate and TyphoonAssembly#activateWithCollaboratingAssemblies:
* instead.
*/
@interface TyphoonAssemblyActivator : NSObject

+ (instancetype)withAssemblies:(NSArray *)assemblies;

+ (instancetype)withAssembly:(TyphoonAssembly *)assembly;

- (void)activate;

@end
