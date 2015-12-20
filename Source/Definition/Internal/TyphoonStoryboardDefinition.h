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

- (id)initWithStoryboardName:(NSString *)storyboardName viewControllerId:(NSString *)viewControllerId;
- (id)initWithStoryboard:(UIStoryboard *)storyboard viewControllerId:(NSString *)viewControllerId;

@end
