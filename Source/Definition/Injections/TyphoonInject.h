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
 * These methods are primarily intended to be used within TyphoonBlockDefinition blocks, although they will work
 * with regular TyphoonDefinitions too.
 */
@interface TyphoonInject : NSObject

+ (id)byType:(id)classOrProtocol;

+ (id)byConfigKey:(NSString *)configKey;

+ (id)byConfigKey:(NSString *)configKey type:(id)classOrProtocol;

@end


/**
 * Class-typed alternatives to TyphoonInject methods.
 */
@interface NSObject (TyphoonInject)

+ (instancetype)typhoonInjectByType;

+ (instancetype)typhoonInjectByConfigKey:(NSString *)configKey;

@end
