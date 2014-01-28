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


@interface TyphoonStackElement : NSObject

@property(nonatomic, strong, readonly) NSString* key;
@property(nonatomic, strong, readonly) id instance;


+ (instancetype)itemWithKey:(NSString*)key instance:(id)instance;

- (NSString*)description;


@end