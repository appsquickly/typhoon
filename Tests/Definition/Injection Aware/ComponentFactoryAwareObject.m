////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "ComponentFactoryAwareObject.h"

@implementation ComponentFactoryAwareObject
{
    id factory;
}

@synthesize factory;

- (void)typhoonSetFactory:(TyphoonComponentFactory *)theFactory
{
    factory = theFactory;
}

- (id)initWithComponentFactory:(TyphoonComponentFactory *)_factory
{
    self = [super init];
    if (self) {
        [self typhoonSetFactory:_factory];
    }
    return self;
}

@end
