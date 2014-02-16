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


#import "Typhoon.h"
#import "CampaignQuest.h"
#import "OCLogTemplate.h"


@implementation CampaignQuest

- (id)initWithImageUrl:(NSURL *)imageUrl
{
    self = [super init];
    if (self) {
        _imageUrl = imageUrl;
    }

    return self;
}

- (NSString *)questName
{
    return @"Campaign Quest";
}

- (void)questBeforePropertyInjection
{
    LogTrace(@"###### My dependencies have not yet been injected. Here's what I look like: %@", [self description]);
}


- (void)questAfterPropertyInjection
{
    LogTrace(@"$$$$$$$$$$$$$$$$$ My dependencies have been injected. And I know look like this: %@", [self description]);
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.imageUrl=%@", self.imageUrl];
    [description appendString:@">"];
    return description;
}


@end