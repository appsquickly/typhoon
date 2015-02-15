////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonDefinition.h"
#import "TyphoonDefinition+Option.h"
#import "TyphoonComponentFactory.h"
#import <Foundation/Foundation.h>

@class TyphoonComponentFactory;

/**
* @ingroup Assembly
*
* Provides a concise way to declare and encapsulate the architecture of an application in one or more classes that describe
* how components collaborate together.
*
* Prior to activation the assembly interface returns TyphoonDefinitions. After activation assembly interface poses in
* of a TyphoonComponentFactory to return built instances.
*
* ## Example:
*
* @code

MyAssembly* assembly = [MyAssembly assembly];
[[TyphoonAssemblyActivator withAssembly:assembly] activate];
AnalyticsService* service = [assembly analyticsService];

@endcode
*
* The TyphoonAssembly provides:
*
* - a way to easily define multiple components of the same class or protocol
* - Avoids the use of "magic strings" for component resolution and wiring
* - Allows the use of IDE features like refactoring and code completion.
*
*/
@interface TyphoonAssembly : NSObject<TyphoonComponentFactory>

+ (instancetype)assembly;

/**
* Returns the [TyphoonComponentFactory defaultFactory] posing as a TyphoonAssembly.
*/
+ (instancetype)defaultAssembly;

@end
