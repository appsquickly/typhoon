////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "Knight.h"
#import "TyphoonPropertyInjectionDelegate.h"


@interface CavalryMan : Knight<TyphoonPropertyInjectionDelegate>

@property (nonatomic) float hitRatio;

- (id)initWithQuest:(id<Quest>)quest hitRatio:(float)hitRatio;


@end