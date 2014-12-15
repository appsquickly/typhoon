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
#import "TyphoonComponentPostProcessor.h"
#import "TyphoonOrdered.h"

typedef id (^PostProcessBlock)(id);

@interface TyphoonComponentPostProcessorMock : NSObject <TyphoonComponentPostProcessor, TyphoonOrdered>

- (id)initWithOrder:(NSInteger)order;

@property(nonatomic, copy) PostProcessBlock postProcessBlock;

@end