//
//  UnsatisfiableClassGDependsOnFInInitializer.m
//  Tests
//
//  Created by Robert Gilliam on 7/28/13.
//
//

#import "UnsatisfiableClassGDependsOnFInInitializer.h"

@implementation UnsatisfiableClassGDependsOnFInInitializer

- (id)initWithF:(UnsatisfiableClassFDependsOnGInInitializer *)dependencyOnF;
{
    self = [super init];
    if (!self) {return nil;}


    return self;
}

@end
