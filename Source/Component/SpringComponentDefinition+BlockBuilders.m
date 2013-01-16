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


#import "SpringComponentDefinition+BlockBuilders.h"
#import "SpringComponentInitializer.h"
#import "SpringComponentDefinition.h"


@implementation SpringComponentDefinition (BlockBuilders)

/* ====================================================================================================================================== */
#pragma mark - No injection



+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz
{
    return [[SpringComponentDefinition alloc] initWithClazz:clazz key:nil];
}

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key
{
    return [[SpringComponentDefinition alloc] initWithClazz:clazz key:key];
}


/* ====================================================================================================================================== */
#pragma mark Anonymous keys

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz initializer:(SpringInitializerBlock)initializer
{
    return [SpringComponentDefinition definitionWithClass:clazz key:nil initializer:initializer properties:nil];
}

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz properties:(SpringPropertyInjectionBlock)properties
{
    return [SpringComponentDefinition definitionWithClass:clazz key:nil initializer:nil properties:properties];
}

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz initializer:(SpringInitializerBlock)initializer
        properties:(SpringPropertyInjectionBlock)properties
{
    return [SpringComponentDefinition definitionWithClass:clazz key:nil initializer:initializer properties:properties];
}


/* ====================================================================================================================================== */
#pragma mark Explicit keys
+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key initializer:(SpringInitializerBlock)initializer
        properties:(SpringPropertyInjectionBlock)properties
{

    SpringComponentDefinition* definition = [[SpringComponentDefinition alloc] initWithClazz:clazz key:key];
    if (initializer)
    {
        SpringComponentInitializer* componentInitializer = [[SpringComponentInitializer alloc] init];
        definition.initializer = componentInitializer;
        __weak SpringComponentInitializer* weakInitializer = componentInitializer;
        initializer(weakInitializer);
    }
    if (properties)
    {
        __weak SpringComponentDefinition* weakDefinition = definition;
        properties(weakDefinition);
    }
    return definition;
}

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key initializer:(SpringInitializerBlock)initializer
{
    return [SpringComponentDefinition definitionWithClass:clazz key:key initializer:initializer properties:nil];
}

+ (SpringComponentDefinition*)definitionWithClass:(Class)clazz key:(NSString*)key properties:(SpringPropertyInjectionBlock)properties
{
    return [SpringComponentDefinition definitionWithClass:clazz key:key initializer:nil properties:properties];
}


@end