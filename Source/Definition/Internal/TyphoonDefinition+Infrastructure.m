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


#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonDefinition_Infrastructure)

#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonResource.h"
#import "TyphoonInitializer.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonReferenceDefinition.h"

@implementation TyphoonDefinition (Infrastructure)

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (instancetype)withClass:(Class)clazz key:(NSString *)key
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:key];
}


+ (instancetype)propertyPlaceholderWithResource:(id <TyphoonResource>)resource
{
    return [self propertyPlaceholderWithResources:@[resource]];
}

+ (instancetype)propertyPlaceholderWithResources:(NSArray *)resources
{
    TyphoonDefinition
        *definition = [self withClass:[TyphoonPropertyPlaceholderConfigurer class] initialization:^(TyphoonInitializer *initializer) {

        initializer.selector = @selector(configurerWithResourceList:);
        [initializer injectWithObjectInstance:resources];

    }];
    definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), [[resources firstObject] description]];
    return definition;
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithClass:(Class)clazz key:(NSString *)key
{
    return [self initWithClass:clazz key:key factoryComponent:nil];
}

- (id)init
{
    return [self initWithClass:nil key:nil factoryComponent:nil];
}

- (id)initWithClass:(Class)clazz key:(NSString *)key factoryComponent:(NSString *)factoryComponent
{
    self = [super init];
    if (self) {
        _type = clazz;
        _key = [key copy];
        _scope = TyphoonScopeObjectGraph;
        _injectedProperties = [[NSMutableSet alloc] init];
        if (factoryComponent) {
            _factory = [TyphoonReferenceDefinition definitionReferringToComponent:factoryComponent];
        }
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (void)dealloc
{
    //Null out the __unsafe_unretained property on initializer
    [_initializer setDefinition:nil];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)validateRequiredParametersAreSet
{
    if (_type == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
}


@end
