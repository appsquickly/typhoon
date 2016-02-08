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


#import "TyphoonDefinition.h"

@interface TyphoonDefinition (Config)

/**
 * Factory method for a TyphoonConfigPostProcessor. Don't use it in test targets!
 * @param fileName The config filename to load. File should be placed in main bundle
 * @return a definition.
 */
+ (instancetype)withConfigName:(NSString *)fileName;

/**
 * Factory method for a TyphoonConfigPostProcessor.
 * @param fileName    The config filename to load.
 * @param fileBundle  The bundle, where the config file is placed
 * @return a definition.
 */
+ (instancetype)withConfigName:(NSString *)fileName bundle:(NSBundle *)fileBundle;

/**
 * Factory method for a TyphoonConfigPostProcessor.
 * @param filePath The path to config file to load.
 * @return a definition.
 */
+ (instancetype)withConfigPath:(NSString *)filePath;

#pragma mark - Deprecated methods

+ (instancetype)configDefinitionWithName:(NSString *)fileName DEPRECATED_MSG_ATTRIBUTE("use -withConfigName: instead");
+ (instancetype)configDefinitionWithName:(NSString *)fileName bundle:(NSBundle *)fileBundle DEPRECATED_MSG_ATTRIBUTE("use -withConfigName:bundle: instead");
+ (instancetype)configDefinitionWithPath:(NSString *)filePath DEPRECATED_MSG_ATTRIBUTE("use -withConfigPath: instead");

@end
