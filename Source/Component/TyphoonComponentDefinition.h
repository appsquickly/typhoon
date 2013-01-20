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

@class TyphoonComponentInitializer;
@protocol TyphoonInjectedProperty;

typedef enum
{
    TyphoonComponentLifeCycleSingleton,
    TyphoonComponentLifeCyclePrototype
} TyphoonComponentLifecycle;


@interface TyphoonComponentDefinition : NSObject
{
    NSMutableSet* _injectedProperties;
}

@property(nonatomic, readonly) Class type;
@property(nonatomic, strong, readonly) NSString* key;
@property(nonatomic, strong, readonly) NSString* factoryComponent;
@property(nonatomic, strong) TyphoonComponentInitializer* initializer;
@property(nonatomic) SEL beforePropertyInjection;
@property(nonatomic) SEL afterPropertyInjection;
@property(nonatomic, strong, readonly) NSSet* injectedProperties;
@property(nonatomic) TyphoonComponentLifecycle lifecycle;


- (id)initWithClass:(Class)clazz key:(NSString*)key;

- (id)initWithClass:(Class)clazz key:(NSString*)key factoryComponent:(NSString*)factoryComponent;

- (void)injectProperty:(NSString*)propertyName;

- (void)injectProperty:(NSString*)propertyName withDefinition:(TyphoonComponentDefinition*)definition;

- (void)injectProperty:(NSString*)propertyName withReference:(NSString*)reference;

- (void)injectProperty:(NSString*)propertyName withValueAsText:(NSString*)textValue;

- (void)addInjectedProperty:(id <TyphoonInjectedProperty>)property;

- (NSSet*)propertiesInjectedByValue;

- (NSSet*)propertiesInjectedByType;

- (NSSet*)propertiesInjectedByReference;

@end