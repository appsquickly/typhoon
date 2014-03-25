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

@class TyphoonStackElement;
@class TyphoonRuntimeArguments;

@interface TyphoonCallStack : NSObject

+ (instancetype)stack;

- (void)push:(TyphoonStackElement *)stackItem;

- (TyphoonStackElement *)pop;

- (TyphoonStackElement *)peekForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args;

- (BOOL)isResolvingKey:(NSString *)key withArgs:(TyphoonRuntimeArguments *)args;

- (BOOL)isEmpty;


@end
