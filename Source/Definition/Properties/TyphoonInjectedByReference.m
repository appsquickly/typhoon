//
// Created by Robert Gilliam on 1/3/14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectedByReference.h"


@implementation TyphoonInjectedByReference
{

}

- (instancetype)initWithReference:(NSString *)reference isProxied:(BOOL)proxied {
    self = [super init];
    if (self)
    {
        _reference = reference;
        _proxied = proxied;
    }

    return self;
}

- (BOOL)isByReference
{
    return YES;
}

@end