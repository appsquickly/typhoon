//
// Created by Aleksey Garbarev on 04.06.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"

@interface NemoCoreSecondViewController : NSObject
@end

@interface NemoCoreFirstViewController : NSObject
@end

@interface NemoCoreRootViewController : NSObject
@end

@interface NemoCoreNemoAssembly : TyphoonAssembly

- (TyphoonDefinition *)rootViewController;
- (TyphoonDefinition *)firstViewController;
- (TyphoonDefinition *)secondViewController;

@end

@interface NemoCoreSecondAssembly : NemoCoreNemoAssembly
@end