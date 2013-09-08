////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactoryPostProcessor.h"

@interface TyphoonComponentFactoryPostProcessorMock : NSObject<TyphoonComponentFactoryPostProcessor>

@property (nonatomic, assign) BOOL postProcessingCalled;

@end
