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


@interface TyphoonStackItem : NSObject

@property(nonatomic, strong, readonly) TyphoonDefinition* definition;
@property(nonatomic, strong, readonly) id instance;


+ (instancetype)itemWithDefinition:(TyphoonDefinition*)definition instance:(id)instance;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToItem:(TyphoonStackItem*)item;

- (NSUInteger)hash;



@end