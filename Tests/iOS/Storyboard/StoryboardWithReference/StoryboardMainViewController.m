////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "StoryboardMainViewController.h"
#import "Model.h"

@implementation StoryboardMainViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.countOfModelInstanceInjections = 0;
    }
    return self;
}

- (void)setModel:(Model *)model
{
    self.countOfModelInstanceInjections++;
    _model = model;
}

- (void)setButton:(UIButton *)button {
    _button = button;
    NSLog(@"setButton %@",button);
}

@end
