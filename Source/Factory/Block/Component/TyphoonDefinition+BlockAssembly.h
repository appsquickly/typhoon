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
#import "TyphoonDefinition.h"

@class TyphoonInitializer;
@class TyphoonDefinition;


typedef void(^TyphoonInitializationBlock)(TyphoonInitializer* initializer);

typedef void(^TyphoonPropertyInjectionBlock)(TyphoonDefinition* propertyInjector);


@interface TyphoonDefinition (BlockAssembly)



/* ====================================================================================================================================== */
#pragma mark No injection

+ (TyphoonDefinition*)withClass:(Class)clazz;

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key;


/* ====================================================================================================================================== */
#pragma mark Initializer and property injection

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties;

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization;


+ (TyphoonDefinition*)withClass:(Class)clazz properties:(TyphoonPropertyInjectionBlock)properties;


/* ====================================================================================================================================== */
- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition;

@end