//
//  Castle.m
//  Tests
//
//  Created by Robert Gilliam on 8/1/13.
//
//

#import "Castle.h"

@implementation Castle

- (id)initWithMoat:(Moat *)aMoat
{
    self = [super init];
    if (!self) return nil;
    
    _moat = aMoat;
    
    return self;
}

@end
