////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
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
* @ingroup Factory
*
*/
@interface TyphoonBlockComponentFactory : TyphoonComponentFactory

+ (id)factoryWithAssembly:(TyphoonAssembly *)assembly;

+ (id)factoryWithAssemblies:(NSArray *)assemblies;

- (id)initWithAssembly:(TyphoonAssembly *)assembly;

- (id)initWithAssemblies:(NSArray *)assemblies;

/**
* Convenience method for casting the factory to an TyphoonAssembly sub-class. TyphoonBlockComponentFactory allows using a TyphoonAssembly
 * interface to pose in front of the factory, in order to resolve components. This avoids the requirement to use "magic strings" when
 * multiple components with the same class are configured in different ways.
 *
 * ##Example:
 @code

 MyAssemblyType* assembly = [factory asAssembly];
//Use the assembly interface instead of a 'magic string'
AnalyticsService* service = [assembly analyticsService];

 @endcode
*/
- (id)asAssembly;

@end


