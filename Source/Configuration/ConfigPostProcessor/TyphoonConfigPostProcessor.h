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
#import "TyphoonComponentFactoryPostProcessor.h"

@protocol TyphoonResource;

/**
* @ingroup Configuration
*/
@interface TyphoonConfigPostProcessor : NSObject <TyphoonComponentFactoryPostProcessor>

/**
*  You can manage TyphoonConfigPostProcessor registry by mapping configuration classes for file extensions
*  Configuration class instance must conforms TyphoonConfiguration protocol
*  */
+ (void)registerConfigurationClass:(Class)configClass forExtension:(NSString *)typeExtension;

/** list of all supported path extensions (configuration types) */
+ (NSArray *)availableExtensions;

+ (TyphoonConfigPostProcessor *)configurer;

/** Append resource found in main bundle by name */
- (void)useResourceWithName:(NSString *)name;

/** Append resource loaded from file at path */
- (void)useResourceAtPath:(NSString *)path;

/** Append TyphoonResource with specified extension (@see availableExtensions method) */
- (void)useResource:(id<TyphoonResource>)resource withExtension:(NSString *)typeExtension;

@end

@interface TyphoonConfigPostProcessor (Deprecated)

+ (TyphoonConfigPostProcessor *)configurerWithResource:(id <TyphoonResource>)resource DEPRECATED_MSG_ATTRIBUTE("check useResource... methods");

+ (TyphoonConfigPostProcessor *)configurerWithResources:(id <TyphoonResource>)first, ...NS_REQUIRES_NIL_TERMINATION DEPRECATED_MSG_ATTRIBUTE("check useResource... methods");

+ (TyphoonConfigPostProcessor *)configurerWithResourceList:(NSArray *)resources DEPRECATED_MSG_ATTRIBUTE("check useResource... methods");

- (void)usePropertyStyleResource:(id<TyphoonResource>)resource DEPRECATED_MSG_ATTRIBUTE("check useResource... methods");

@end

id TyphoonConfig(NSString *configKey);

