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


#import "CampaignQuest.h"
#import "SpringLogTemplate.h"


@implementation CampaignQuest

- (NSString*)questName
{
    return @"Campaign Quest";
}

- (void)questBeforePropertyInjection
{
    SpringDebug(@"###### My dependencies have not yet been injected. Here's what I look like: %@", [self description]);
}


- (void)questAfterPropertyInjection
{
    SpringDebug(@"$$$$$$$$$$$$$$$$$ My dependencies have been injected. And I know look like this: %@", [self description]);
}

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.imageUrl=%@", self.imageUrl];
    [description appendString:@">"];
    return description;
}


@end