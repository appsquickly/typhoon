////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"
#import "QuestProvider.h"

@class MiddleAgesAssembly;
@class Knight;


@interface CollaboratingMiddleAgesAssembly : TyphoonAssembly

- (id)knightWithExternalQuest;

@property(nonatomic, strong, readwrite) TyphoonAssembly <QuestProvider> *quests;

@end