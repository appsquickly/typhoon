////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <Typhoon/Typhoon.h>
#import "StoryboardControllerDependency.h"


@interface StoryboardFirstViewController : UIViewController

@property(nonatomic, strong) StoryboardControllerDependency *dependency;

@end