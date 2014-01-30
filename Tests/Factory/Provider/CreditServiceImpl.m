////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "CreditServiceImpl.h"

static NSUInteger sInstanceCounter = 0;

@implementation CreditServiceImpl

+ (NSUInteger)instanceCounter
{
    return sInstanceCounter;
}

- (id)init
{
    sInstanceCounter += 1;
    return [super init];
}

@end
