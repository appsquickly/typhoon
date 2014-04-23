////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "Knight.h"

@interface CavalryMan : Knight 

@property(nonatomic) float hitRatio;

@property(nonatomic, strong) NSArray *propertyInjectedAsInstance;

- (id)initWithQuest:(id <Quest>)quest hitRatio:(float)hitRatio;


@end