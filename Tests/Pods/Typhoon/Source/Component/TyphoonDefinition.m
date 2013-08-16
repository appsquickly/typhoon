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


#import "TyphoonInitializer.h"
#import "TyphoonDefinition.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonPropertyInjectedByValue.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"


@implementation TyphoonDefinition

/* ====================================================================================================================================== */
#pragma mark - Factory methods

+ (TyphoonDefinition*)withClass:(Class)clazz
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:key];
}

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(void (^)(TyphoonInitializer*))initialization
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz properties:(void (^)(TyphoonDefinition*))properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:nil properties:properties];
}

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(void (^)(TyphoonInitializer*))initialization
        properties:(void (^)(TyphoonDefinition*))properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:properties];
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(void (^)(TyphoonInitializer*))initialization
        properties:(void (^)(TyphoonDefinition*))properties
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

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(void (^)(TyphoonInitializer*))initialization
{
    return [TyphoonDefinition withClass:clazz key:key initialization:initialization properties:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key properties:(void (^)(TyphoonDefinition*))properties
{
    return [TyphoonDefinition withClass:clazz key:key initialization:nil properties:properties];
}


/* ============================================================ Initializers ============================================================ */
- (id)initWithClass:(Class)clazz key:(NSString*)key factoryComponent:(NSString*)factoryComponent
{
    self = [super init];
    if (self)
    {
        _type = clazz;
        _key = [key copy];
        _factoryReference = [factoryComponent copy];
        _injectedProperties = [[NSMutableSet alloc] init];
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (id)initWithClass:(Class)clazz key:(NSString*)key
{
    return [self initWithClass:clazz key:key factoryComponent:nil];
}

- (id)init
{
    return [self initWithClass:nil key:nil factoryComponent:nil];
}


/* ========================================================== Interface Methods ========================================================= */
- (void)injectProperty:(SEL)selector
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByType alloc] initWithName:NSStringFromSelector(selector)]];
}

- (void)injectProperty:(SEL)selector withValueAsText:(NSString*)textValue
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByValue alloc] initWithName:NSStringFromSelector(selector) value:textValue]];
}

- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition
{
    [self injectProperty:selector withReference:definition.key];
}

- (void)injectProperty:(SEL)withSelector asCollection:(void (^)(TyphoonPropertyInjectedAsCollection*))collectionValues;
{
    TyphoonPropertyInjectedAsCollection* propertyInjectedAsCollection =
            [[TyphoonPropertyInjectedAsCollection alloc] initWithName:NSStringFromSelector(withSelector)];

    if (collectionValues)
    {
        __unsafe_unretained TyphoonPropertyInjectedAsCollection* weakPropertyInjectedAsCollection = propertyInjectedAsCollection;
        collectionValues(weakPropertyInjectedAsCollection);
    }
    [_injectedProperties addObject:propertyInjectedAsCollection];
}


- (NSSet*)injectedProperties
{
    return [_injectedProperties copy];
}

- (void)setInitializer:(TyphoonInitializer*)initializer
{
    _initializer = initializer;
    [_initializer setComponentDefinition:self];
}

- (void)setFactory:(TyphoonDefinition*)factory
{
    _factory = factory;
    [self setFactoryReference:_factory.key];
}


/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    return [NSString stringWithFormat:@"Definition: class='%@'", NSStringFromClass(_type)];
}

- (void)dealloc
{
    //Null out the __unsafe_unretained property on initializer
    [_initializer setComponentDefinition:nil];
}

/* ============================================================ Private Methods ========================================================= */
- (void)validateRequiredParametersAreSet
{
    if (_type == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
}


@end