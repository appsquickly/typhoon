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

#import "TyphoonStoryboardDefinitionContext.h"

@interface TyphoonStoryboardDefinitionContext ()

@property (assign, nonatomic, readwrite) TyphoonStoryboardDefinitionType type;
@property (strong, nonatomic, readwrite) id storyboardName;
@property (strong, nonatomic, readwrite) id viewControllerId;

@end

@implementation TyphoonStoryboardDefinitionContext

- (instancetype)initWithType:(TyphoonStoryboardDefinitionType)type viewControllerId:(id)viewControllerId storyboardName:(id)storyboardName
{
    self = [super init];
    if (self) {
        _type = type;
        _viewControllerId = viewControllerId;
        _storyboardName = storyboardName;
    }
    return self;
}

+ (instancetype)contextWithStoryboardName:(id)storyboardName viewControllerId:(id)viewControllerId
{
    return [[[self class] alloc] initWithType:TyphoonStoryboardDefinitionByNameType
                             viewControllerId:viewControllerId
                               storyboardName:storyboardName];
}

+ (instancetype)contextForPreconfiguredStoryboardWithViewControllerId:(id)viewControllerId
{
    return [[[self class] alloc] initWithType:TyphoonStoryboardDefinitionByFactoryType
                             viewControllerId:viewControllerId
                               storyboardName:nil];
}

@end
