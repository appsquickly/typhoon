////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "SpringComponentDefinition.h"

@class SpringComponentInitializer;
@class SpringComponentDefinition;


typedef void(^SpringInitializerBlock)(SpringComponentInitializer* initializer);

typedef void(^SpringPropertyInjectionBlock)(SpringComponentDefinition* propertyInjector);


@interface SpringComponentDefinition (BlockBuilders)


/* ====================================================================================================================================== */
#pragma mark No injection

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz;

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key;


/* ====================================================================================================================================== */
#pragma mark Anonymous keys

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz initializer:(SpringInitializerBlock)initializer
        properties:(SpringPropertyInjectionBlock)properties;

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz initializer:(SpringInitializerBlock)initializer;


+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz properties:(SpringPropertyInjectionBlock)properties;


/* ====================================================================================================================================== */
#pragma mark - Explicit keys
+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key initializer:(SpringInitializerBlock)initializer;

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key properties:(SpringPropertyInjectionBlock)properties;

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key initializer:(SpringInitializerBlock)initializer
        properties:(SpringPropertyInjectionBlock)properties;


@end