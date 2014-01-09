//
// Created by Robert Gilliam on 1/9/14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonMiscUtils.h"


@implementation TyphoonMiscUtils
{

}

static NSArray * ordinalsThroughThree;
+ (void)initialize
{
    ordinalsThroughThree = @[@"th", @"st", @"nd", @"rd"];
}

+ (NSString*)ordinalForIndex:(NSUInteger)index
{
    NSUInteger lastDigit = index % 10;
    if (index > 3 && index < 20) {
        return [NSString stringWithFormat:@"%lu%@", index, @"th"];
    }else if (lastDigit <= 3) {
        return [NSString stringWithFormat:@"%lu%@", index, ordinalsThroughThree[lastDigit]];
    }else{
        return [NSString stringWithFormat:@"%lu%@", index, @"th"];
    }
}
@end