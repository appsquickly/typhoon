////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
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

@property (nonatomic, strong, readwrite) TyphoonAssembly<QuestProvider> *quests;

- (id)knightWithExternalQuest;

- (id)knightWithCollaboratingFoobar:(NSString *)foorbar;

@end