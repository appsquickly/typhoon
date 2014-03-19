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



#import "Knight.h"
#import "CampaignQuest.h"


@implementation Knight

/* ============================================================ Initializers ============================================================ */
- (id)initWithQuest:(id <Quest>)quest
{
    return [self initWithQuest:quest damselsRescued:0];
}

- (id)initWithQuest:(id <Quest>)quest damselsRescued:(NSUInteger)damselsRescued
{
    self = [super init];
    if (self) {
        _quest = quest;
        _damselsRescued = damselsRescued;
    }
    return self;
}

- (id)initWithQuest:(id <Quest>)quest favoriteDamsels:(NSArray *)favoriteDamsels;
{
    self = [super init];
    if (self) {
        _quest = quest;
        _favoriteDamsels = favoriteDamsels;
    }
    return self;
}

- (id)initWithDamselsRescued:(NSUInteger)damselsRescued foo:(id)foobar
{
    self = [super init];
    if (self) {
        _damselsRescued = damselsRescued;
        _foobar = foobar;

    }
    return self;
}

+ (id)knightWithDamselsRescued:(NSUInteger)damselsRescued
{
    return [[[self class] alloc] initWithDamselsRescued:damselsRescued foo:nil];
}

/* ========================================================== Interface Methods ========================================================= */

- (void)setQuest:(id<Quest>)quest andDamselsRescued:(NSUInteger)damselsRescued
{
    self.quest = quest;
    self.damselsRescued = damselsRescued;
}

- (void)setQuest:(CampaignQuest *)quest
{
    _quest = quest;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.quest=%@", self.quest];
    [description appendFormat:@", self.foobar=%@", self.foobar];
    [description appendFormat:@", self.damselsRescued=%lu", (unsigned long) self.damselsRescued];
    [description appendString:@">"];
    return description;
}


@end