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