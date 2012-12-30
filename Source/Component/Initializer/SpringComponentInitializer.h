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

@interface SpringComponentInitializer : NSObject
{
    NSMutableArray* _injectedParameters;
    NSArray* _parameterNames;
}

@property(nonatomic, readonly) SEL selector;
@property(nonatomic, readonly) BOOL isFactoryMethod;

- (id)initWithSelector:(SEL)initializer;

- (id)initWithSelector:(SEL)initializer isFactoryMethod:(BOOL)isFactoryMethod;

- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference;

- (void)injectParameterAt:(NSUInteger)index withReference:(NSString*)reference;

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol;

- (void)injectParameterAt:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol;

- (NSArray*)injectedParameters;

- (NSInvocation*)asInvocationFor:(id)classOrInstance;

@end