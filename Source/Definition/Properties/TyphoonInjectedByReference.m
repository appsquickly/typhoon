////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonInjectedByReference.h"


@implementation TyphoonInjectedByReference


- (instancetype)initWithReference:(NSString*)reference
{
    self = [super init];
    if (self)
    {
        _reference = reference;
    }

    return self;
}

@end