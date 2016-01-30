////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonDefinition.h"

@class TyphoonMethod;

@interface TyphoonDefinition ()

@property (nonatomic, readonly) TyphoonMethod *initializer;

@property (nonatomic, getter = isInitializerGenerated) BOOL initializerGenerated;

@end
