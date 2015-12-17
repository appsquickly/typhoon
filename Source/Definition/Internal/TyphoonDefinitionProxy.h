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

@interface TyphoonDefinitionProxy : NSProxy

- (instancetype)initWithClass:(Class)clazz configuration:(TyphoonDefinitionBlock)configuration;

- (TyphoonDefinition *)__buildTyphoonDefinition;

@end
