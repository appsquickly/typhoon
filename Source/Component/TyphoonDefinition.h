////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class TyphoonInitializer;
@class TyphoonDefinition;
@protocol TyphoonInjectedProperty;

typedef enum
{
    TyphoonScopeDefault,
    TyphoonScopeSingleton
} TyphoonScope;

typedef void(^TyphoonInitializationBlock)(TyphoonInitializer* initializer);

typedef void(^TyphoonPropertyInjectionBlock)(TyphoonDefinition* propertyInjector);


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


/* ====================================================================================================================================== */
#pragma mark Factory methods

+ (TyphoonDefinition*)withClass:(Class)clazz;

+ (TyphoonDefinition*)withClass:(Class)clazz key:(NSString*)key;

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization
        properties:(TyphoonPropertyInjectionBlock)properties;

+ (TyphoonDefinition*)withClass:(Class)clazz initialization:(TyphoonInitializationBlock)initialization;

+ (TyphoonDefinition*)withClass:(Class)clazz properties:(TyphoonPropertyInjectionBlock)properties;

/* ====================================================================================================================================== */
#pragma mark Initializers

- (id)initWithClass:(Class)clazz key:(NSString*)key;

- (id)initWithClass:(Class)clazz key:(NSString*)key factoryComponent:(NSString*)factoryComponent;

/* ====================================================================================================================================== */
#pragma mark Injection

- (void)injectProperty:(SEL)withSelector;

- (void)injectProperty:(SEL)withSelector withValueAsText:(NSString*)textValue;

- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition;

@end