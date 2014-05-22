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
#import "TyphoonDefinition.h"

@protocol TyphoonPropertyInjection;
@protocol TyphoonInjection;

typedef void(^TyphoonInjectionsEnumerationBlock)(id injection, id*injectionToReplace, BOOL*stop);

typedef enum {
    TyphoonInjectionsEnumerationOptionProperties = 1 << 0,
    TyphoonInjectionsEnumerationOptionMethods = 1 << 2
} TyphoonInjectionsEnumerationOption;

#define TyphoonInjectionsEnumerationOptionAll (TyphoonInjectionsEnumerationOptionProperties | TyphoonInjectionsEnumerationOptionMethods)

@interface TyphoonDefinition (InstanceBuilder)

- (void)setType:(Class)type;

- (NSSet *)injectedProperties;

- (NSSet *)injectedMethods;

- (void)enumerateInjectionsOfKind:(Class)injectionClass options:(TyphoonInjectionsEnumerationOption)options
                       usingBlock:(TyphoonInjectionsEnumerationBlock)block;

- (BOOL)hasRuntimeArgumentInjections;

- (void)addInjectedProperty:(id <TyphoonPropertyInjection>)property;


@end
