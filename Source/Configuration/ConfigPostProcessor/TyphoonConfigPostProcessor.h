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
#import "TyphoonDefinitionPostProcessor.h"

@protocol TyphoonResource;

/**
* @ingroup Configuration
*/
@interface TyphoonConfigPostProcessor : NSObject<TyphoonDefinitionPostProcessor>


+ (instancetype)processor;

/**
* Returns a post processor for the bundle resource with the given name.
*/
+ (instancetype)forResourceNamed:(NSString *)resourceName;

/**
 * Returns a post processor for the bundle resource with the given name and bundle.
 */
+ (instancetype)forResourceNamed:(NSString *)resourceName inBundle:(NSBundle *)bundle;

/**
* Returns a post processor for the resource at the specified path.
*/
+ (instancetype)forResourceAtPath:(NSString *)path;


/**
*  You can manage TyphoonConfigPostProcessor registry by mapping configuration classes for file extensions
*  Configuration class instance must conforms TyphoonConfiguration protocol
*  */
+ (void)registerConfigurationClass:(Class)configClass forExtension:(NSString *)typeExtension;

/** list of all supported path extensions (configuration types) */
+ (NSArray *)availableExtensions;


/** Append resource found in main bundle by name */
- (void)useResourceWithName:(NSString *)name;

/** Append resource found by name and bundle */
- (void)useResourceWithName:(NSString *)name bundle:(NSBundle *)bundle;

/** Append resource loaded from file at path */
- (void)useResourceAtPath:(NSString *)path;

/** Append TyphoonResource with specified extension (@see availableExtensions method) */
- (void)useResource:(id<TyphoonResource>)resource withExtension:(NSString *)typeExtension;

@end

id TyphoonConfig(NSString *configKey);

