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

typedef NS_ENUM(NSUInteger, TyphoonStoryboardDefinitionType) {
    TyphoonStoryboardDefinitionByNameType = 0,
    TyphoonStoryboardDefinitionByFactoryType
};

@interface TyphoonStoryboardDefinitionContext : NSObject

@property (assign, nonatomic, readonly) TyphoonStoryboardDefinitionType type;
@property (strong, nonatomic, readonly) id storyboardName;
@property (strong, nonatomic, readonly) id viewControllerId;

+ (instancetype)contextForPreconfiguredStoryboardWithViewControllerId:(id)viewControllerId;
+ (instancetype)contextWithStoryboardName:(id)storyboardName viewControllerId:(id)viewControllerId;

@end
