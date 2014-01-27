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

@class TyphoonStackItem;

@interface TyphoonResolutionStack : NSObject

+ (instancetype)stack;

- (void)push:(TyphoonStackItem*)stackItem;

- (TyphoonStackItem*)pop;

- (TyphoonStackItem*)peek;

- (TyphoonStackItem*)peekWithKey:(NSString*)key;

- (BOOL)isEmpty;

@end
