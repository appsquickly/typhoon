////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "TyphoonDefinition.h"

@protocol TyphoonPropertyInjection;
@protocol TyphoonInjection;
@class TyphoonComponentFactory;
@class TyphoonRuntimeArguments;

typedef void(^TyphoonInjectionsEnumerationBlock)(id injection, id*injectionToReplace, BOOL*stop);

typedef NS_OPTIONS(NSInteger, TyphoonInjectionsEnumerationOption) {
    TyphoonInjectionsEnumerationOptionProperties = 1 << 0,
    TyphoonInjectionsEnumerationOptionMethods = 1 << 2,
    TyphoonInjectionsEnumerationOptionAll = TyphoonInjectionsEnumerationOptionProperties | TyphoonInjectionsEnumerationOptionMethods,
};

@interface TyphoonDefinition (InstanceBuilder)

- (TyphoonMethod *)beforeInjections;

- (NSSet *)injectedProperties;

- (NSOrderedSet *)injectedMethods;

- (TyphoonMethod *)afterInjections;

- (void)enumerateInjectionsOfKind:(Class)injectionClass options:(TyphoonInjectionsEnumerationOption)options
                       usingBlock:(TyphoonInjectionsEnumerationBlock)block;

- (BOOL)hasRuntimeArgumentInjections;

- (void)addInjectedProperty:(id <TyphoonPropertyInjection>)property;

- (void)addInjectedPropertyIfNotExists:(id <TyphoonPropertyInjection>)property;

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args;

@end
