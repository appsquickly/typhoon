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


#import <Foundation/Foundation.h>

/**
 * This category is intended to use with TyphoonBlockDefinition (although it will work as TyphoonConfig() too).
 *
 * (With TyphoonBlockDefinitions, we lack info about config value type, e.g. is it NSString or NSNumber.)
 */
@interface NSObject (TyphoonConfig)

+ (instancetype)typhoonForConfigKey:(NSString *)configKey;

@end
