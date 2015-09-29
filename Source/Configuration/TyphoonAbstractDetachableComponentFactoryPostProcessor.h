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


@interface TyphoonAbstractDetachableComponentFactoryPostProcessor : NSObject <TyphoonDefinitionPostProcessor>
{
    TyphoonComponentFactory* _factory;
    NSMutableDictionary *_rollbackDefinitions;
}

/**
 Restores a component factory back to its initial state after post processing.
 */
- (void)rollback;

@end
