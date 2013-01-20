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
#import "TyphoonComponentDefinition.h"

@class TyphoonComponentInitializer;
@class TyphoonComponentDefinition;


typedef void(^TyphoonInitializationBlock)(TyphoonComponentInitializer* initializer);

typedef void(^TyphoonPropertyInjectionBlock)(TyphoonComponentDefinition* propertyInjector);


@interface TyphoonComponentDefinition (BlockBuilders)


/* ====================================================================================================================================== */
#pragma mark No injection

+ (TyphoonComponentDefinition*)withClass:(Class)clazz;

+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key;


/* ====================================================================================================================================== */
#pragma mark Anonymous keys

+ (TyphoonComponentDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties;

+ (TyphoonComponentDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization;


+ (TyphoonComponentDefinition*)withClass:(Class)clazz properties:(TyphoonPropertyInjectionBlock)properties;


/* ====================================================================================================================================== */
#pragma mark - Explicit keys

+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializationBlock)initialization;

+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key properties:(TyphoonPropertyInjectionBlock)properties;

+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties;


@end