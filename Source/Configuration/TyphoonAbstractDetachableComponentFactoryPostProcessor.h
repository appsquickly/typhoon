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
#import "TyphoonComponentFactoryPostProcessor.h"


@interface TyphoonAbstractDetachableComponentFactoryPostProcessor : NSObject <TyphoonComponentFactoryPostProcessor>
{
    TyphoonComponentFactory* _factory;
    NSMutableArray *_rollbackDefinitions;
}

/**
 Restores a component factory back to its initial state after post processing.
 */
- (void)rollback;

@end