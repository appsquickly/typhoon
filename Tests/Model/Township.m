//
//  Township.m
//  Tests
//
//  Created by Robert Gilliam on 8/3/13.
//
//

#import "Township.h"

@implementation Township {
    Knight *sheriff;
    Moat *moat;
}

@synthesize sheriff, moat;

- (id)initWithSheriff:(Knight *)theSheriff moat:(Moat *)theMoat;
{
    self = [super init];
    if (!self) return nil;
    
    sheriff = theSheriff;
    moat = theMoat;
    
    return self;
}

@end
