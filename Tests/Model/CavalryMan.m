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


#import "CavalryMan.h"


@implementation CavalryMan

- (id)initWithQuest:(id <Quest>)quest hitRatio:(float)hitRatio;
{
    self = [super init];
    if (self)
    {
        self.quest = quest;
        _hitRatio = hitRatio;
    }

    return self;
}

- (void)beforePropertiesSet
{
    NSLog(@"#################### CavalryMan before properties set");
}

- (void)afterPropertiesSet
{
    NSLog(@"############# CavalryMan after properties set");
}

@end