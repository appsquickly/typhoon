////////////////////////////////////////////////////////////////////////////////
//
//  58 NORTH
//  Copyright 2013 58 North
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of 58 North
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"
#import "QuestProvider.h"

@class MiddleAgesAssembly;


@interface CollaboratingMiddleAgesAssembly : TyphoonAssembly

@property (nonatomic, strong, readwrite) id<QuestProvider> quests;

- (id)knightWithExternalQuest;

@end