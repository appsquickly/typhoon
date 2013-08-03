//
//  TyphoonRuntimeObjectPlaceholder.m
//  Static Library
//
//  Created by Robert Gilliam on 8/3/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonRuntimeObjectPlaceholder.h"

@implementation TyphoonRuntimeObjectPlaceholder

- (id)init
{
    [NSException raise:NSInternalInconsistencyException format:@"%@: use the designated init, not %@.", [self class], NSStringFromSelector(_cmd)];
    return nil;
}

- (id)initWithIndexInArguments:(NSUInteger)theIndex;
{
    self = [super init];
    if (!self) return nil;
    
    _indexInArguments = theIndex;
    
    return self;
}

@end
