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

@class TyphoonDefinition;
@class TyphoonRuntimeArguments;

typedef void(^TyphoonInstanceCompleteBlock)(id instance);


@interface TyphoonStackElement : NSObject

@property(nonatomic, strong, readonly) NSString *key;
@property(nonatomic, strong, readonly) TyphoonRuntimeArguments *args;
@property(nonatomic, strong, readonly) id instance;

/* Raises a circular init exception if instance in initializing state. */

+ (instancetype)elementWithKey:(NSString *)key args:(TyphoonRuntimeArguments *)args;

- (NSString *)description;

- (BOOL)isInitializingInstance;

- (void)addInstanceCompleteBlock:(TyphoonInstanceCompleteBlock)completeBlock;

- (void)takeInstance:(id)instance;

@end