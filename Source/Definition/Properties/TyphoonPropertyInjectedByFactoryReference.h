//
//  TyphoonPropertyInjectedByFactoryReference.h
//  Typhoon
//
//  Created by Aleksey Garbarev on 23.01.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPropertyInjectedByReference.h"

@interface TyphoonPropertyInjectedByFactoryReference : TyphoonPropertyInjectedByReference

@property (nonatomic, readonly) NSString *keyPath;

- (instancetype)initWithName:(NSString*)name reference:(NSString*)reference keyPath:(NSString *)keyPath;
- (instancetype)initWithName:(NSString *)name reference:(NSString *)reference keyPath:(NSString *)keyPath isProxied:(BOOL)proxied;


@end
