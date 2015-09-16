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
#import "TyphoonDefinitionPostProcessor.h"

@class TyphoonDefinition;


@interface TyphoonFactoryAutoInjectionPostProcessor : NSObject <TyphoonDefinitionPostProcessor>

- (void)postProcessDefinition:(TyphoonDefinition *)definition;

- (NSArray *)autoInjectedPropertiesForClass:(Class)clazz;

@end
