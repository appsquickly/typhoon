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

@interface TyphoonDefinition (Storyboard)

/**
 This family of methods produces TyphoonDefinitions especially for UIViewControllers instantiated via storyboards.
 It requires either the definition for the target storyboard or its name.
 These definitions can use the same scopes as usual ones.
 
 @param storyboardName The name of the storyboard in the main bundle
 @param storyboard     The TyphoonDefinition of the storyboard
 @param storyboardId   The target ViewController storyboard identifier
 @param injections     The definition configuration block
 
 @return TyphoonDefinition for UIViewController
 */
+ (id)withStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId;
+ (id)withStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId configuration:(TyphoonDefinitionBlock)injections;
+ (id)withStoryboard:(id)storyboard storyboardId:(NSString *)storyboardId;
+ (id)withStoryboard:(id)storyboard storyboardId:(NSString *)storyboardId configuration:(TyphoonDefinitionBlock)injections;

@end
