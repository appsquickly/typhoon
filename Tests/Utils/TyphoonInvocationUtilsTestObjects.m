//
//  TyphoonInvocationUtilsTestObjects.m
//  Tests
//
//  Created by Aleksey Garbarev on 04.02.14.
//
//

#import "TyphoonInvocationUtilsTestObjects.h"

@implementation ObjectInitRetained

- (instancetype)init {
    return [super init];
}

@end

@implementation ObjectNewRetained

+ (instancetype)newObject; {
    ObjectNewRetained *object = [[ObjectNewRetained alloc] init];
    return object;
}

@end

@implementation ObjectNewAutorelease

+ (instancetype)object {
    ObjectNewAutorelease *object = [[ObjectNewAutorelease alloc] init];
    return [object autorelease];
}

@end


@implementation ObjectInitCluster

- (instancetype)initOldRelease {
    [self release];

    self = [[ObjectInitCluster alloc] init];

    return self;
}


- (instancetype)initOldAutorelease {
    [self autorelease];

    self = [[ObjectInitCluster alloc] init];

    return self;
}

- (instancetype)initReturnNil {
    [self release];

    return nil;
}

@end

