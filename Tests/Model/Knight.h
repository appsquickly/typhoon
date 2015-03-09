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

@class CampaignQuest;
@class Fort;

#import "Quest.h"


@interface Knight : NSObject

@property(nonatomic, strong) id <Quest> quest;
@property(nonatomic, strong) id <NSObject> foobar;
@property(nonatomic) NSUInteger damselsRescued;
@property(nonatomic) BOOL hasHorseWillTravel;
@property(nonatomic, strong, readonly) id <Quest> readOnlyQuest;
@property(nonatomic, strong) NSArray *favoriteDamsels;
@property(nonatomic, strong) NSSet *friends;
@property(nonatomic, strong) NSDictionary *friendsDictionary;
@property(nonatomic, strong) Fort *homeFort;

+ (id)knightWithDamselsRescued:(NSUInteger)damselsRescued;

- (void)setQuest:(id<Quest>)quest andDamselsRescued:(NSUInteger)damselsRescued;

- (void)setFoobar:(id<NSObject>)foobar andHasHorse:(BOOL)hasHorse friends:(NSSet *)friends;

- (id)initWithQuest:(id <Quest>)quest;

- (id)initWithQuest:(id <Quest>)quest damselsRescued:(NSUInteger)damselsRescued;

- (id)initWithQuest:(id <Quest>)quest favoriteDamsels:(NSArray *)favoriteDamsels;

- (id)initWithDamselsRescued:(NSUInteger)damselsRescued foo:(id)foobar;

- (NSString *)description;


- (void)setFavoriteQuest:(id<Quest>)quest;

- (id<Quest>)favoriteQuest;


@end
