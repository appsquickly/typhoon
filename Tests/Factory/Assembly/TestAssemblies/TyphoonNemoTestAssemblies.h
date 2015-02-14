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