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
#import "Quest.h"

@class Fort;

@interface CampaignQuest : NSObject <Quest>

@property(nonatomic, strong) NSURL *imageUrl;
@property(nonatomic, strong) Fort *fort;

- (id)initWithImageUrl:(NSURL *)imageUrl;

- (void)questBeforePropertyInjection;

- (void)questAfterPropertyInjection;

@end