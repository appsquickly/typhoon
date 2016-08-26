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

#import "LoadedView.h"

@implementation LoadedView

+ (instancetype)loadFromNib
{
    return [[[NSBundle bundleForClass:self] loadNibNamed:NSStringFromClass([self class])
                                                   owner:self
                                                 options:NULL] firstObject];
}

@end
