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


#import "TyphoonComponentDefinition+BlockBuilders.h"
#import "TyphoonComponentInitializer.h"
#import "TyphoonComponentDefinition.h"


@implementation TyphoonComponentDefinition (BlockBuilders)

/* ====================================================================================================================================== */
#pragma mark - No injection



+ (TyphoonComponentDefinition*)withClass:(Class)clazz
{
    return [[TyphoonComponentDefinition alloc] initWithClass:clazz key:nil];
}

+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key
{
    return [[TyphoonComponentDefinition alloc] initWithClass:clazz key:key];
}


/* ====================================================================================================================================== */
#pragma mark Anonymous keys

+ (TyphoonComponentDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization
{
    return [TyphoonComponentDefinition withClass:clazz key:nil initialization:initialization properties:nil];
}

+ (TyphoonComponentDefinition*)withClass:(Class)clazz properties:(TyphoonPropertyInjectionBlock)properties
{
    return [TyphoonComponentDefinition withClass:clazz key:nil initialization:nil properties:properties];
}

+ (TyphoonComponentDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties
{
    return [TyphoonComponentDefinition withClass:clazz key:nil initialization:initialization properties:properties];
}


/* ====================================================================================================================================== */
#pragma mark Explicit keys
+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties
{

    TyphoonComponentDefinition* definition = [[TyphoonComponentDefinition alloc] initWithClass:clazz key:key];
    if (initialization)
    {
        TyphoonComponentInitializer* componentInitializer = [[TyphoonComponentInitializer alloc] init];
        definition.initializer = componentInitializer;
        __weak TyphoonComponentInitializer* weakInitializer = componentInitializer;
        initialization(weakInitializer);
    }
    if (properties)
    {
        __weak TyphoonComponentDefinition* weakDefinition = definition;
        properties(weakDefinition);
    }
    return definition;
}

+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializationBlock)initialization
{
    return [TyphoonComponentDefinition withClass:clazz key:key initialization:initialization properties:nil];
}

+ (TyphoonComponentDefinition*)withClass:(Class)clazz key:(NSString*)key properties:(TyphoonPropertyInjectionBlock)properties
{
    return [TyphoonComponentDefinition withClass:clazz key:key initialization:nil properties:properties];
}


@end