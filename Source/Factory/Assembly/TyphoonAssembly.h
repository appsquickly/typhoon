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

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+Option.h"

#if TARGET_OS_IPHONE
#import "TyphoonDefinition+Storyboard.h"
#endif

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

MyAssembly* assembly = [[MyAssembly new] activate];
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
@interface TyphoonAssembly : NSObject <TyphoonComponentFactory>

+ (__nonnull instancetype)assembly;

/**
* Returns the [TyphoonComponentFactory defaultFactory] posing as a TyphoonAssembly.
*/
+ (__nullable instancetype)defaultAssembly;


/**
 *  Activates the assembly. The concrete declared type of any collaborating assemblies will be used. If
 * collaborating assemblies are backed by a protocol then they must be specified explicitly. 
 *
 * @see activateWithCollaboratingAssemblies
 *
 */
- (__nonnull instancetype)activated;

/**
 * Activates the assembly, attaching the specified config resource name from the application bundle.
 *
 * This method is a convenience for:
@code

TyphoonConfigPostProcessor *processor = [TyphoonConfigPostProcessor processor];
[processor useResourceWithName:@"Config_production.plist"];
[self attachPostProcessor:processor];
[self activate];

@endcode
 *
 */
- (__nonnull instancetype)activatedWithConfigResourceName:(NSString  * __nonnull)resourceName;


/**
 *  Activates the assembly, explicitly setting the types for collaborating assemblies.
 *
 *  @param assemblies The explicit types to be used for collaborating assemblies. For example if this assembly
 * references another assembly of type NetworkProvider, specifying a subclass TestNetworkProvider will override
 * the base type. If collaborating assemblies are backed by a protocol, they must be specified explicitly. 
 */
- (__nonnull instancetype)activatedWithCollaboratingAssemblies:(NSArray * __nullable)assemblies;

- (__nonnull instancetype)activatedWithCollaboratingAssemblies:(NSArray *__nullable)assemblies postProcessors:(NSArray * __nullable)postProcessors;

@end

@interface TyphoonAssembly(Unavailable)

- (__nonnull instancetype)activate __attribute__((unavailable("Use `activated` non-mutating version instead.")));;
- (__nonnull instancetype)activateWithConfigResourceName:(NSString  * __nonnull)resourceName __attribute__((unavailable("Use `activatedWithConfigResourceName:` non-mutating version instead.")));
- (__nonnull instancetype)activateWithCollaboratingAssemblies:(NSArray * __nullable)assemblies __attribute__((unavailable("Use `activatedWithCollaboratingAssemblies:` non-mutating version instead.")));;
- (__nonnull instancetype)activateWithCollaboratingAssemblies:(NSArray *__nullable)assemblies postProcessors:(NSArray * __nullable)postProcessors __attribute__((unavailable("Use `activatedWithCollaboratingAssemblies:postProcessors:` non-mutating version instead.")));;

@end
