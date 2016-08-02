//
//  LoadedView.m
//  Typhoon
//
//  Created by Smal Vadim on 01/08/16.
//  Copyright © 2016 typhoonframework.org. All rights reserved.
//

#import "LoadedView.h"

@implementation LoadedView

+ (instancetype)loadFromNib
{
    return [[[NSBundle bundleForClass:self] loadNibNamed:NSStringFromClass([self class])
                                                   owner:self
                                                 options:NULL] firstObject];
}

@end
