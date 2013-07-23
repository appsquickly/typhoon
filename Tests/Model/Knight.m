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
    if (self)
    {
        _quest = quest;
        _damselsRescued = damselsRescued;
    }
    return self;
}

/* ========================================================== Interface Methods ========================================================= */
- (void)setQuest:(CampaignQuest*)quest
{
    _quest = quest;
}

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.quest=%@", self.quest];
    [description appendFormat:@", self.foobar=%@", self.foobar];
    [description appendFormat:@", self.damselsRescued=%lu", (unsigned long)self.damselsRescued];
    [description appendString:@">"];
    return description;
}


@end