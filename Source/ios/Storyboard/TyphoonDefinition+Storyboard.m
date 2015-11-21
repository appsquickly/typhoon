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

#import "TyphoonDefinition+Storyboard.h"

@implementation TyphoonDefinition (Storyboard)

+ (id)withStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId
{
    return [self withStoryboardName:storyboardName storyboardId:storyboardId configuration:nil];
}

+ (id)withStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId configuration:(TyphoonDefinitionBlock)injections
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName
                                                         bundle:[NSBundle mainBundle]];
    return [self withStoryboard:storyboard storyboardId:storyboardId configuration:injections];
}

+ (id)withStoryboard:(id)storyboard storyboardId:(NSString *)storyboardId
{
    return [self withStoryboard:storyboard storyboardId:storyboardId configuration:nil];
}

+ (id)withStoryboard:(id)storyboard storyboardId:(NSString *)storyboardId configuration:(TyphoonDefinitionBlock)injections
{
    return [self withFactory:storyboard
                    selector:@selector(instantiateViewControllerWithIdentifier:)
                  parameters:^(TyphoonMethod *factoryMethod) {
                      [factoryMethod injectParameterWith:storyboardId];
                  }
               configuration:injections];
}

@end
