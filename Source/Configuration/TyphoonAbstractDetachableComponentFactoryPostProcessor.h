////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
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