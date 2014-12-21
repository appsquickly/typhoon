////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonInstancePostProcessorMock.h"


@implementation TyphoonInstancePostProcessorMock
{
    NSInteger _order;
}

- (id)initWithOrder:(NSInteger)order
{
    self = [super init];
    if (self) {
        _order = order;
    }
    return self;
}

- (id)postProcessInstance:(id)component
{
    if (_postProcessBlock) {
        return _postProcessBlock(component);
    }
    return component;
}

- (NSInteger)order
{
    return _order;
}

@end