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


#import <Typhoon/TyphoonCollaboratingAssemblyProxy.h>
#import "TyphoonInitializer.h"
#import "TyphoonDefinition.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonPropertyInjectedWithStringRepresentation.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonPropertyInjectedAsObjectInstance.h"
#import "TyphoonDefinition+Infrastructure.h"


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
    BOOL fromCollaboratingAssemblyProxy = (definition.type == [TyphoonCollaboratingAssemblyProxy class]);
    [self injectProperty:selector withReference:definition.key fromCollaboratingAssemblyProxy:fromCollaboratingAssemblyProxy];
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
   [self injectProperty:selector withValueAsText:[@(intValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withUnsignedInt:(unsigned int)unsignedIntValue
{
  [self injectProperty:selector withValueAsText:[@(unsignedIntValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withShort:(short)shortValue
{
    [self injectProperty:selector withValueAsText:[@(shortValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withUnsignedShort:(unsigned short)unsignedIntShort
{
  [self injectProperty:selector withValueAsText:[@(unsignedIntShort) stringValue]];
}

- (void)injectProperty:(SEL)selector withLong:(long)longValue
{
    [self injectProperty:selector withValueAsText:[@(longValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withUnsignedLong:(unsigned long)unsignedLongValue
{
  [self injectProperty:selector withValueAsText:[@(unsignedLongValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withLongLong:(long long)longLongValue
{
    [self injectProperty:selector withValueAsText:[@(longLongValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withUnsignedLongLong:(unsigned long long)unsignedLongLongValue
{
  [self injectProperty:selector withValueAsText:[@(unsignedLongLongValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withUnsignedChar:(unsigned char)unsignedCharValue
{
    [self injectProperty:selector withValueAsText:[@(unsignedCharValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withFloat:(float)floatValue
{
    [self injectProperty:selector withValueAsText:[NSString stringWithFormat:@"%f", floatValue]];
}

- (void)injectProperty:(SEL)selector withDouble:(double)doubleValue
{
    [self injectProperty:selector withValueAsText:[NSString stringWithFormat:@"%f", doubleValue]];
}

- (void)injectProperty:(SEL)selector withBool:(BOOL)boolValue
{
    [self injectProperty:selector withValueAsText:[@(boolValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withInteger:(NSInteger)integerValue
{
    [self injectProperty:selector withValueAsText:[@(integerValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withUnsignedInteger:(NSUInteger)unsignedIntegerValue
{
    [self injectProperty:selector withValueAsText:[@(unsignedIntegerValue) stringValue]];
}

- (void)injectProperty:(SEL)selector withClass:(Class)classValue
{
    [self injectProperty:selector withValueAsText:NSStringFromClass(classValue)];
}

- (void)injectProperty:(SEL)selector withSelector:(SEL)selectorValue
{
    [self injectProperty:selector withValueAsText:NSStringFromSelector(selectorValue)];
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
#pragma mark - Utility Methods

- (NSString*)description
{
    return [NSString stringWithFormat:@"Definition: class='%@'", NSStringFromClass(_type)];
}


@end
