//
//  UnsatisfiableClassFDependsOnAInInitializer.m
//  Tests
//
//  Created by Robert Gilliam on 7/28/13.
//
//

#import "UnsatisfiableClassFDependsOnGInInitializer.h"

@implementation UnsatisfiableClassFDependsOnGInInitializer

- (id)initWithG:(UnsatisfiableClassGDependsOnFInInitializer *)dependencyOnG;
{
    self = [super init];
    if (!self) {return nil;}


    return self;
}

@end
