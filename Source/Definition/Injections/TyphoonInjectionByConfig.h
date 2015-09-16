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
#import "TyphoonAbstractInjection.h"

@protocol TyphoonInjection;


@interface TyphoonInjectionByConfig : TyphoonAbstractInjection

@property (nonatomic, strong) id<TyphoonInjection> configuredInjection;
@property (nonatomic, strong, readonly) NSString *configKey;

- (instancetype)initWithConfigKey:(NSString *)configKey;

@end
