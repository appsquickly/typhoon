////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "Sword.h"


@implementation Sword

/* ============================================================ Initializers ============================================================ */
- (id)initWithSpecification:(NSString *)specification
{
    self = [super init];
    if (self) {
        _specification = specification;
    }

    return self;
}


- (NSString *)description
{
    return _specification;
}

@end