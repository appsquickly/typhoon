//
//  TyphoonPropertyInjectedByFactoryReference.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 23.01.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPropertyInjectedByFactoryReference.h"

@implementation TyphoonPropertyInjectedByFactoryReference

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithName:(NSString*)name reference:(NSString*)reference keyPath:(NSString *)keyPath
{
    return [self initWithName:name reference:reference keyPath:keyPath isProxied:NO];
}

- (instancetype)initWithName:(NSString *)name reference:(NSString *)reference keyPath:(NSString *)keyPath isProxied:(BOOL)proxied
{
    self = [super initWithName:name reference:reference isProxied:proxied];
    if (self) {
        _keyPath = keyPath;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionTypeByFactoryReference;
}

@end
