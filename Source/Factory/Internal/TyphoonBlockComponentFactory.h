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
#import "TyphoonComponentFactory.h"
#import "TyphoonRuntimeArguments.h"

@class TyphoonAssembly;

/**
* @ingroup Assembly
*
*/
@interface TyphoonBlockComponentFactory : TyphoonComponentFactory

+ (id)factoryWithAssembly:(TyphoonAssembly *)assembly;

+ (id)factoryWithAssemblies:(NSArray *)assemblies;

- (id)initWithAssembly:(TyphoonAssembly *)assembly;

- (id)initWithAssemblies:(NSArray *)assemblies;


@end


