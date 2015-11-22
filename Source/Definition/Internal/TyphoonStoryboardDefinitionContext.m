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
@property (strong, nonatomic, readwrite) NSString *storyboardName;
@property (strong, nonatomic, readwrite) NSString *storyboardId;

@end

@implementation TyphoonStoryboardDefinitionContext

- (instancetype)initWithType:(TyphoonStoryboardDefinitionType)type storyboardId:(NSString *)storyboardId storyboardName:(NSString *)storyboardName
{
    self = [super init];
    if (self) {
        _type = type;
        _storyboardId = storyboardId;
        _storyboardName = storyboardName;
    }
    return self;
}

+ (instancetype)contextWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId
{
    return [[[self class] alloc] initWithType:TyphoonStoryboardDefinitionByNameType
                                 storyboardId:storyboardId
                               storyboardName:storyboardName];
}

+ (instancetype)contextForPreconfiguredStoryboardWithStoryboardId:(NSString *)storyboardId
{
    return [[[self class] alloc] initWithType:TyphoonStoryboardDefinitionByFactoryType
                                 storyboardId:storyboardId
                               storyboardName:nil];
}

@end
