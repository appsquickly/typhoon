//
// Created by Robert Gilliam on 1/3/14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectedByReference.h"


@implementation TyphoonInjectedByReference
{

}

- (instancetype)initWithReference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy {
    self = [super init];
    if (self)
    {
        _reference = reference;
        _fromCollaboratingAssemblyProxy = fromCollaboratingAssemblyProxy;
    }

    return self;
}

- (BOOL)isByReference
{
    return YES;
}

@end