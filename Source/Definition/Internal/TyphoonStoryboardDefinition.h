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

#import <Typhoon/Typhoon.h>

@interface TyphoonStoryboardDefinition : TyphoonFactoryDefinition

- (id)initWithStoryboardName:(id)storyboardName viewControllerId:(id)viewControllerId;
- (id)initWithStoryboard:(UIStoryboard *)storyboard viewControllerId:(id)viewControllerId;

@end
