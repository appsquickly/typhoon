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

typedef enum
{
    TyphoonScopeDefault,
    TyphoonScopeSingleton
} TyphoonScope;

typedef void(^TyphoonInitializerBlock)(TyphoonInitializer* initializer);
typedef void(^TyphoonDefinitionBlock)(TyphoonDefinition* definition);



@interface TyphoonDefinition : NSObject
{
    NSMutableSet* _injectedProperties;
    NSString* _factoryReference;
}

@property(nonatomic, readonly) Class type;
@property(nonatomic, strong) NSString* key;
@property(nonatomic, strong) TyphoonInitializer* initializer;
@property(nonatomic) SEL beforePropertyInjection;
@property(nonatomic) SEL afterPropertyInjection;
@property(nonatomic, strong, readonly) NSSet* injectedProperties;
@property(nonatomic) TyphoonScope scope;
@property(nonatomic, strong) TyphoonDefinition* factory;

/**
 * Say if the componant (scoped as a singleton) should be lazily instantiated.
 */
@property(nonatomic, assign, getter = isLazy) BOOL lazy;


/* ====================================================================================================================================== */
#pragma mark Factory methods

+ (TyphoonDefinition*)withClass:(Class)clazz;

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key;

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization properties:(TyphoonDefinitionBlock)properties;

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializerBlock)initialization;

+ (TyphoonDefinition*)withClass:(Class)clazz properties:(TyphoonDefinitionBlock)properties;

/* ====================================================================================================================================== */
#pragma mark Initializers

- (id)initWithClass:(Class)clazz key:(NSString*)key;

- (id)initWithClass:(Class)clazz key:(NSString*)key factoryComponent:(NSString*)factoryComponent;

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

- (void)injectProperty:(SEL)selector withObjectInstance:(id)instance;

/**
* Injects property with the value represented by the given text. The text will be used to create an instance of a class matching the
* required type.
*
* @see TyphoonTypeConverterRegistry for details on declaring your own type converters.
*/
- (void)injectProperty:(SEL)withSelector withValueAsText:(NSString*)textValue;

- (void)injectProperty:(SEL)withSelector asCollection:(void (^)(TyphoonPropertyInjectedAsCollection*))collectionValues;

@end