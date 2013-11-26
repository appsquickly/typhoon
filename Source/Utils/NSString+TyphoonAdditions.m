//
// Created by Robert Gilliam on 11/18/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import "NSString+TyphoonAdditions.h"


@implementation NSString (TyphoonAdditions)

- (BOOL)_typhoon_contains:(NSString*)aString
{
    return [self rangeOfString:aString].location != NSNotFound;
}


@end