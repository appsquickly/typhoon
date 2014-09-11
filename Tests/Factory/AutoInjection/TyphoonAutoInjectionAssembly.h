//
// Created by Aleksey Garbarev on 12.09.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"

@protocol Quest;
@class Fort;
@class AutoInjectionKnight;


@interface TyphoonAutoInjectionAssembly : TyphoonAssembly

- (id<Quest>)defaultQuest;

- (Fort *)defaultFort;

@end

@interface TyphoonAutoInjectionAssemblyWithKnight : TyphoonAssembly

- (AutoInjectionKnight *)autoInjectedKnight;

@end