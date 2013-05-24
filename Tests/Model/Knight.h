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

@class CampaignQuest;

#import "Quest.h"


@interface Knight : NSObject

@property(nonatomic, strong) id <Quest> quest;
@property(nonatomic, strong) id <NSObject> foobar;
@property(nonatomic) NSUInteger damselsRescued;
@property(nonatomic) BOOL hasHorseWillTravel;
@property(nonatomic, strong, readonly) id <Quest> readOnlyQuest;
@property(nonatomic, strong) NSArray* favoriteDamsels;
@property(nonatomic, strong) NSSet* friends;


- (id)initWithQuest:(id <Quest>)quest;

- (id)initWithQuest:(id <Quest>)quest damselsRescued:(NSUInteger)damselsRescued;

- (NSString*)description;


@end
