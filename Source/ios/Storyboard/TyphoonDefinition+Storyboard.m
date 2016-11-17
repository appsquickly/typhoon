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

+ (id)withStoryboardName:(NSString *)storyboardName viewControllerId:(NSString *)viewControllerId
{
    return [self withStoryboardName:storyboardName viewControllerId:viewControllerId configuration:nil];
}

+ (id)withStoryboardName:(NSString *)storyboardName viewControllerId:(NSString *)viewControllerId configuration:(TyphoonDefinitionBlock)injections
{
    TyphoonStoryboardDefinition *definition = [[TyphoonStoryboardDefinition alloc] initWithStoryboardName:storyboardName viewControllerId:viewControllerId];
    
    if (injections) {
        injections(definition);
    }
    
    return definition;
}

+ (id)withStoryboard:(id)storyboard viewControllerId:(NSString *)viewControllerId
{
    return [self withStoryboard:storyboard viewControllerId:viewControllerId configuration:nil];
}

+ (id)withStoryboard:(id)storyboard viewControllerId:(NSString *)viewControllerId configuration:(TyphoonDefinitionBlock)injections
{
    TyphoonStoryboardDefinition *definition = [[TyphoonStoryboardDefinition alloc] initWithStoryboard:storyboard viewControllerId:viewControllerId];
    
    if (injections) {
        injections(definition);
    }
    
    return definition;
}

@end
