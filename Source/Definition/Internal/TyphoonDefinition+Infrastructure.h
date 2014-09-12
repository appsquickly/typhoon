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

#import "TyphoonDefinition.h"

@class TyphoonConfigPostProcessor;
@protocol TyphoonResource;

/**
 Declares short-hand definition factory methods for infrastructure components.
 */
@interface TyphoonDefinition (Infrastructure)

@property(nonatomic, strong) TyphoonRuntimeArguments *currentRuntimeArguments;

/**
* Returns a definition with the given class and key. In the block-style assembly, keys are auto-generated, however infrastructure components
* may specify their own key.
*/
+ (instancetype)withClass:(Class)clazz key:(NSString *)key;

/**
Factory method for a TyphoonConfigPostProcessor.
@param fileName The config filename to load. File should be placed in main bundle
@return a definition.
*/
+ (instancetype)configDefinitionWithName:(NSString *)fileName;

/**
Factory method for a TyphoonConfigPostProcessor.
@param filePath The path to config file to load.
@return a definition.
*/

+ (instancetype)configDefinitionWithPath:(NSString *)filePath;


+ (instancetype)configDefinitionWithResource:(id <TyphoonResource>)resource __attribute__((unavailable("Use configDefinitionWithName instead")));
+ (instancetype)configDefinitionWithResources:(NSArray *)array __attribute__((unavailable("Use configDefinitionWithName instead")));

- (id)initWithClass:(Class)clazz key:(NSString *)key;

- (id)initWithClass:(Class)clazz key:(NSString *)key factoryComponent:(NSString *)factoryComponent;


@end
