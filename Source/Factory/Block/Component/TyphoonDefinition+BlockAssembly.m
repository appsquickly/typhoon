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



#import "TyphoonDefinition+BlockAssembly.h"
#import "TyphoonInitializer+BlockAssembly.h"


@implementation TyphoonDefinition (BlockAssembly)

/* ====================================================================================================================================== */
#pragma mark - No injection



+ (TyphoonDefinition*)withClass:(Class)clazz
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:key];
}


/* ====================================================================================================================================== */
#pragma mark Anonymous keys

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz properties:(TyphoonPropertyInjectionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:nil properties:properties];
}

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:properties];
}


/* ====================================================================================================================================== */
#pragma mark Explicit keys
+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties
{

    TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:clazz key:key];
    if (initialization)
    {
        TyphoonInitializer* componentInitializer = [[TyphoonInitializer alloc] init];
        definition.initializer = componentInitializer;
        __unsafe_unretained TyphoonInitializer* weakInitializer = componentInitializer;
        initialization(weakInitializer);
    }
    if (properties)
    {
        __unsafe_unretained TyphoonDefinition* weakDefinition = definition;
        properties(weakDefinition);
    }
    return definition;
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializationBlock)initialization
{
    return [TyphoonDefinition withClass:clazz key:key initialization:initialization properties:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key properties:(TyphoonPropertyInjectionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:key initialization:nil properties:properties];
}



/* ====================================================================================================================================== */
- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition
{
    [self injectProperty:selector withReference:definition.key];
}

@end