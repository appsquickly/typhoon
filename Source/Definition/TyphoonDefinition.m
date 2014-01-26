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
#import "TyphoonPropertyInjectedWithStringRepresentation.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonPropertyInjectedAsObjectInstance.h"
#import "TyphoonPropertyInjectedByFactoryReference.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "OCLogTemplate.h"


@implementation TyphoonDefinition

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonDefinition*)withClass:(Class)clazz
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:nil];
}


+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz properties:(TyphoonDefinitionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:nil properties:properties];
}

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization
        properties:(TyphoonDefinitionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:nil initialization:initialization properties:properties];
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializerBlock)initialization
        properties:(TyphoonDefinitionBlock)properties
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
    if (definition.lazy && definition.scope != TyphoonScopeSingleton)
    {
        [NSException raise:NSInvalidArgumentException format:
                @"The lazy attribute is only applicable to singleton scoped definitions, but is set for definition: %@ ", definition];
    }

    return definition;
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key initialization:(TyphoonInitializerBlock)initialization
{
    return [TyphoonDefinition withClass:clazz key:key initialization:initialization properties:nil];
}

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key properties:(TyphoonDefinitionBlock)properties
{
    return [TyphoonDefinition withClass:clazz key:key initialization:nil properties:properties];
}

+ (TyphoonDefinition*)withClass:(Class)clazz factory:(TyphoonDefinition*)_definition selector:(SEL)selector
{
    return [TyphoonDefinition withClass:clazz initialization:^(TyphoonInitializer* initializer)
    {
        [initializer setSelector:selector];
    } properties:^(TyphoonDefinition* definition)
    {
        [definition setFactory:_definition];
    }];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)injectProperty:(SEL)selector
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByType alloc] initWithName:NSStringFromSelector(selector)]];
}

- (void)injectProperty:(SEL)selector withValueAsText:(NSString*)textValue
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedWithStringRepresentation alloc]
            initWithName:NSStringFromSelector(selector) value:textValue]];
}

- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition
{
    [self injectProperty:selector withReference:definition.key];
}

- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition selector:(SEL)factorySelector
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByFactoryReference alloc]
            initWithName:NSStringFromSelector(selector) reference:definition.key keyPath:NSStringFromSelector(factorySelector)]];
}

- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition keyPath:(NSString*)keyPath
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByFactoryReference alloc]
            initWithName:NSStringFromSelector(selector) reference:definition.key keyPath:keyPath]];
}

- (void)injectProperty:(SEL)selector withObjectInstance:(id)instance
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedAsObjectInstance alloc]
            initWithName:NSStringFromSelector(selector) objectInstance:instance]];
}

- (void)injectProperty:(SEL)withSelector asCollection:(void (^)(TyphoonPropertyInjectedAsCollection*))collectionValues;
{
    TyphoonPropertyInjectedAsCollection
            * propertyInjectedAsCollection = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:NSStringFromSelector(withSelector)];

    if (collectionValues)
    {
        __unsafe_unretained TyphoonPropertyInjectedAsCollection* weakPropertyInjectedAsCollection = propertyInjectedAsCollection;
        collectionValues(weakPropertyInjectedAsCollection);
    }
    [_injectedProperties addObject:propertyInjectedAsCollection];
}

- (void)injectProperty:(SEL)selector withInt:(int)intValue
{
    [self injectProperty:selector withObjectInstance:@(intValue)];
}

- (void)injectProperty:(SEL)selector withUnsignedInt:(unsigned int)unsignedIntValue
{
    [self injectProperty:selector withObjectInstance:@(unsignedIntValue)];
}

- (void)injectProperty:(SEL)selector withShort:(short)shortValue
{
    [self injectProperty:selector withObjectInstance:@(shortValue)];
}

- (void)injectProperty:(SEL)selector withUnsignedShort:(unsigned short)unsignedIntShort
{
    [self injectProperty:selector withObjectInstance:@(unsignedIntShort)];
}

- (void)injectProperty:(SEL)selector withLong:(long)longValue
{
    [self injectProperty:selector withObjectInstance:@(longValue)];
}

- (void)injectProperty:(SEL)selector withUnsignedLong:(unsigned long)unsignedLongValue
{
    [self injectProperty:selector withObjectInstance:@(unsignedLongValue)];
}

- (void)injectProperty:(SEL)selector withLongLong:(long long)longLongValue
{
    [self injectProperty:selector withObjectInstance:@(longLongValue)];
}

- (void)injectProperty:(SEL)selector withUnsignedLongLong:(unsigned long long)unsignedLongLongValue
{
    [self injectProperty:selector withObjectInstance:@(unsignedLongLongValue)];
}

- (void)injectProperty:(SEL)selector withUnsignedChar:(unsigned char)unsignedCharValue
{
    [self injectProperty:selector withObjectInstance:@(unsignedCharValue)];
}

- (void)injectProperty:(SEL)selector withFloat:(float)floatValue
{
    [self injectProperty:selector withObjectInstance:@(floatValue)];
}

- (void)injectProperty:(SEL)selector withDouble:(double)doubleValue
{
    [self injectProperty:selector withObjectInstance:@(doubleValue)];
}

- (void)injectProperty:(SEL)selector withBool:(BOOL)boolValue
{
    [self injectProperty:selector withObjectInstance:@(boolValue)];
}

- (void)injectProperty:(SEL)selector withInteger:(NSInteger)integerValue
{
    [self injectProperty:selector withObjectInstance:@(integerValue)];
}

- (void)injectProperty:(SEL)selector withUnsignedInteger:(NSUInteger)unsignedIntegerValue
{
    [self injectProperty:selector withObjectInstance:@(unsignedIntegerValue)];
}

- (void)injectProperty:(SEL)selector withClass:(Class)classValue
{
    [self injectProperty:selector withObjectInstance:classValue];
}

- (void)injectProperty:(SEL)selector withSelector:(SEL)selectorValue
{
    [self injectProperty:selector withObjectInstance:[NSValue valueWithBytes:&selectorValue objCType:@encode(SEL)]];
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

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (TyphoonInitializer*)initializer
{
    if (!_initializer)
    {
        return _parent.initializer;
    }
    return _initializer;
}


- (NSSet*)injectedProperties
{
    NSMutableSet* parentProperties = [_parent injectedProperties] ? [[_parent injectedProperties] mutableCopy] : [NSMutableSet set];

    NSMutableArray* overriddenProperties = [NSMutableArray array];
    [parentProperties enumerateObjectsUsingBlock:^(id obj, BOOL* stop)
    {
        if ([_injectedProperties containsObject:obj])
        {
            [overriddenProperties addObject:obj];
        }
    }];

    for (TyphoonAbstractInjectedProperty* overriddenProperty in overriddenProperties)
    {
        [parentProperties removeObject:overriddenProperty];
    }

    return [[parentProperties setByAddingObjectsFromSet:_injectedProperties] copy];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString*)description
{
    return [NSString stringWithFormat:@"Definition: class='%@', key='%@'", NSStringFromClass(_type), _key];
}


@end
