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

#import "TyphoonStoryboardDefinition.h"

@implementation TyphoonDefinition (Storyboard)

+ (id)withStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId
{
    return [self withStoryboardName:storyboardName storyboardId:storyboardId configuration:nil];
}

+ (id)withStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId configuration:(TyphoonDefinitionBlock)injections
{
    TyphoonStoryboardDefinition *definition = [[TyphoonStoryboardDefinition alloc] initWithStoryboardName:storyboardName storyboardId:storyboardId];
    
    if (injections) {
        injections(definition);
    }
    
    return definition;
}

+ (id)withStoryboard:(id)storyboard storyboardId:(NSString *)storyboardId
{
    return [self withStoryboard:storyboard storyboardId:storyboardId configuration:nil];
}

+ (id)withStoryboard:(id)storyboard storyboardId:(NSString *)storyboardId configuration:(TyphoonDefinitionBlock)injections
{
    TyphoonStoryboardDefinition *definition = [[TyphoonStoryboardDefinition alloc] initWithStoryboard:storyboard storyboardId:storyboardId];
    
    if (injections) {
        injections(definition);
    }
    
    return definition;
}

@end
