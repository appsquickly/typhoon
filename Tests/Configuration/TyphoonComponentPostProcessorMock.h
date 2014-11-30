////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonInstancePostProcessor.h"

typedef id (^PostProcessBlock)(id);

@interface TyphoonComponentPostProcessorMock : NSObject <TyphoonInstancePostProcessor>

@property(nonatomic, copy) PostProcessBlock postProcessBlock;

@end