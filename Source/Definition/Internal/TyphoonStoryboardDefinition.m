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

#import "TyphoonStoryboardDefinition.h"

@implementation TyphoonStoryboardDefinition

- (id)initWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    return [self initWithStoryboard:storyboard storyboardId:storyboardId];
}

- (id)initWithStoryboard:(UIStoryboard *)storyboard storyboardId:(NSString *)storyboardId
{
    return [self initWithFactory:storyboard selector:@selector(instantiateViewControllerWithIdentifier:) parameters:^(TyphoonMethod *method) {
        [method injectParameterWith:storyboardId];
    }];
}

@end
