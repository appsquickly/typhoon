////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonInvocationUtilsTestObjects.h"

@implementation ObjectInitRetained

- (instancetype)init
{
    return [super init];
}

@end

@implementation ObjectNewRetained

+ (instancetype)newObject;
{
    ObjectNewRetained *object = [[ObjectNewRetained alloc] init];
    return object;
}

@end

@implementation ObjectNewAutorelease

+ (instancetype)object
{
    ObjectNewAutorelease *object = [[ObjectNewAutorelease alloc] init];
    return [object autorelease];
}

@end


@implementation ObjectInitCluster

- (instancetype)initOldRelease
{
    [self release];

    self = [[ObjectInitCluster alloc] init];

    return self;
}


- (instancetype)initOldAutorelease
{
    [self autorelease];

    self = [[ObjectInitCluster alloc] init];

    return self;
}

- (instancetype)initReturnNil
{
    [self release];

    return nil;
}

@end

