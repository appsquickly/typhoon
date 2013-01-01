////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class SpringComponentInitializer;
@protocol SpringInjectedProperty;

typedef enum
{
    SpringComponentLifeCycleSingleton,
    SpringComponentLifeCyclePrototype
} SpringComponentLifecycle;

@interface SpringComponentDefinition : NSObject
{
    NSMutableSet* _injectedProperties;
}

@property(nonatomic, readonly) Class type;
@property(nonatomic, strong, readonly) NSString* key;
@property(nonatomic, strong) SpringComponentInitializer* initializer;
@property(nonatomic) SEL afterPropertyInjection;
@property(nonatomic, strong, readonly) NSSet* injectedProperties;
@property(nonatomic) SpringComponentLifecycle lifecycle;


- (id)initWithClazz:(Class)clazz key:(NSString*)key;

- (void)injectProperty:(NSString*)propertyName;

- (void)injectProperty:(NSString*)propertyName withReference:(NSString*)reference;

- (void)injectProperty:(NSString*)propertyName withValueAsText:(NSString*)textValue;

- (void)addInjectedProperty:(id<SpringInjectedProperty>)property;

- (NSString*)description;

@end