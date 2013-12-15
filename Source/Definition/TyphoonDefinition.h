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


#import <Foundation/Foundation.h>

@class TyphoonInitializer;
@class TyphoonDefinition;
@protocol TyphoonInjectedProperty;
@class TyphoonPropertyInjectedAsCollection;

/**
* @ingroup Definition
* Describes the lifecycle of a Typhoon component.
*
* - TyphoonScopeDefault means that a new component is created for each time it is referenced in a collaborator, or retrieved from the
* factory.
*
* - TyphoonScopeSingleton creates a shared instance.
*
*/
typedef enum
{
    TyphoonScopeDefault,
    TyphoonScopeSingleton
} TyphoonScope;


typedef void(^TyphoonInitializerBlock)(TyphoonInitializer* initializer);

typedef void(^TyphoonDefinitionBlock)(TyphoonDefinition* definition);

/**
* @ingroup Definition
*/
@interface TyphoonDefinition : NSObject
{
    Class _type;
    NSString* _key;
    TyphoonInitializer* _initializer;
    NSMutableSet* _injectedProperties;
    NSString* _factoryReference;
}

@property(nonatomic, readonly) Class type;
@property(nonatomic, strong) NSString* key;
@property(nonatomic, strong) TyphoonInitializer* initializer;
@property(nonatomic) SEL beforePropertyInjection;
@property(nonatomic) SEL afterPropertyInjection;
@property(nonatomic, strong) NSSet* injectedProperties;
@property(nonatomic) TyphoonScope scope;
@property(nonatomic, strong) TyphoonDefinition* factory;
@property(nonatomic, strong) TyphoonDefinition* parent;
@property(nonatomic, strong) NSString* parentRef;


/**
 * Say if the component (scoped as a singleton) should be lazily instantiated.
 */
@property(nonatomic, assign, getter = isLazy) BOOL lazy;


/* ====================================================================================================================================== */
#pragma mark Factory methods

+ (TyphoonDefinition*)withClass:(Class)clazz;

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization properties:(TyphoonDefinitionBlock)properties;

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization;

+ (TyphoonDefinition*)withClass:(Class)clazz properties:(TyphoonDefinitionBlock)properties;


/* ====================================================================================================================================== */
#pragma mark Injection

/**
* Injects property with a component from the container that matches the type (class or protocol) of the property.
*/
- (void)injectProperty:(SEL)withSelector;

/**
* Injects property with the given definition.
*/
- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition;

/**
* Injects property with the given object instance.
*/
- (void)injectProperty:(SEL)selector withObjectInstance:(id)instance;

/**
* Injects property with the value represented by the given text. The text will be used to create an instance of a class matching the
* required type.
*
* @see TyphoonTypeConverterRegistry for details on declaring your own type converters.
*/
- (void)injectProperty:(SEL)withSelector withValueAsText:(NSString*)textValue;

/**
* Injects property as a collection.
*/
- (void)injectProperty:(SEL)withSelector asCollection:(void (^)(TyphoonPropertyInjectedAsCollection*))collectionValues;

/**
* Injects property as int.
*/
- (void)injectProperty:(SEL)selector withInt:(int)intValue;

/**
 * Injects property as unsigned int.
 */
- (void)injectProperty:(SEL)selector withUnsignedInt:(unsigned int)unsignedIntValue;

/**
* Injects property as short.
*/
- (void)injectProperty:(SEL)selector withShort:(short)shortValue;

/**
 * Injects property as unsigned short.
 */
- (void)injectProperty:(SEL)selector withUnsignedShort:(unsigned short)unsignedShortValue;

/**
* Injects property as long.
*/
- (void)injectProperty:(SEL)selector withLong:(long)longValue;

/**
 * Injects property as unsigned long.
 */
- (void)injectProperty:(SEL)selector withUnsignedLong:(unsigned long)unsignedLongValue;

/**
* Injects property as long long.
*/
- (void)injectProperty:(SEL)selector withLongLong:(long long)longLongValue;

/**
 * Injects property as unsigned long long.
 */
- (void)injectProperty:(SEL)selector withUnsignedLongLong:(unsigned long long)unsignedLongLongValue;

/**
* Injects property as unsigned char.
*/
- (void)injectProperty:(SEL)selector withUnsignedChar:(unsigned char)unsignedCharValue;

/**
* Injects property as float.
*/
- (void)injectProperty:(SEL)selector withFloat:(float)floatValue;

/**
* Injects property as double.
*/
- (void)injectProperty:(SEL)selector withDouble:(double)doubleValue;

/**
* Injects property as boolean.
*/
- (void)injectProperty:(SEL)selector withBool:(BOOL)boolValue;

/**
 * Injects property as integeger.
 */
- (void)injectProperty:(SEL)selector withInteger:(NSInteger)integerValue;

/**
 * Injects property as unsigned integer.
 */
- (void)injectProperty:(SEL)selector withUnsignedInteger:(NSUInteger)unsignedIntegerValue;

/**
* Injects property as class.
*/
- (void)injectProperty:(SEL)selector withClass:(Class)classValue;

/**
* Injects property as selector.
*/
- (void)injectProperty:(SEL)selector withSelector:(SEL)selectorValue;

@end
