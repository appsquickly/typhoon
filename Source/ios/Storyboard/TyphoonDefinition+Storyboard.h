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
 Produces TyphoonDefinition for UIViewController instantiated via storyboard name.
 Result definition can use the same scopes as usual ones.
 
 @param storyboardName   The name of the storyboard in the main bundle
 @param viewControllerId The target ViewController storyboard identifier
 
 @return TyphoonDefinition for UIViewController
 
 @see withStoryboardName:viewControllerId:configuration:
 */
+ (id)withStoryboardName:(NSString *)storyboardName viewControllerId:(NSString *)viewControllerId;

/**
 Produces TyphoonDefinition for UIViewController instantiated via storyboard name.
 Result definition can use the same scopes as usual ones.
 
 @param storyboardName   The name of the storyboard in the main bundle
 @param viewControllerId The target ViewController storyboard identifier
 @param injections       The definition configuration block
 
 @return TyphoonDefinition for UIViewController
 */
+ (id)withStoryboardName:(NSString *)storyboardName viewControllerId:(NSString *)viewControllerId configuration:(TyphoonDefinitionBlock)injections;

/**
 Produces TyphoonDefinition for UIViewController instantiated via storyboard definition.
 Result definition can use the same scopes as usual ones.
 
 @param storyboard       The TyphoonDefinition of the storyboard
 @param viewControllerId The target ViewController storyboard identifier
 
 @return TyphoonDefinition for UIViewController
 
 @see withStoryboard:viewControllerId:configuration:
 */
+ (id)withStoryboard:(id)storyboard viewControllerId:(NSString *)viewControllerId;

/**
 Produces TyphoonDefinition for UIViewController instantiated via storyboard definition.
 Result definition can use the same scopes as usual ones.
 
 @param storyboard       The TyphoonDefinition of the storyboard
 @param viewControllerId The target ViewController storyboard identifier
 @param injections       The definition configuration block
 
 @return TyphoonDefinition for UIViewController
 */
+ (id)withStoryboard:(id)storyboard viewControllerId:(NSString *)viewControllerId configuration:(TyphoonDefinitionBlock)injections;

@end
