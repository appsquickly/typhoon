////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonMethodSwizzler.h"

@interface TyphoonSwizzlerDefaultImpl : NSObject <TyphoonMethodSwizzler>

+ (instancetype)instance;

@end
