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


#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonResource.h"
#import "TyphoonInitializer.h"

@implementation TyphoonDefinition (Infrastructure)

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:key];
}


+ (TyphoonDefinition *)propertyPlaceholderWithResource:(id<TyphoonResource>)resource {
  
    TyphoonDefinition *definition = [self withClass:[TyphoonPropertyPlaceholderConfigurer class] initialization:^(TyphoonInitializer *initializer) {
        
        initializer.selector = @selector(configurerWithResource:);
        [initializer injectWithObject:resource];
        
    }];
    definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), [resource description]];
    return definition;
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithClass:(Class)clazz key:(NSString*)key
{
    return [self initWithClass:clazz key:key factoryComponent:nil];
}

- (id)init
{
    return [self initWithClass:nil key:nil factoryComponent:nil];
}


@end
