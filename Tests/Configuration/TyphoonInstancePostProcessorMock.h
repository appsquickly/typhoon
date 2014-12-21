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
#import "TyphoonInstancePostProcessor.h"
#import "TyphoonOrdered.h"

typedef id (^PostProcessBlock)(id);

@interface TyphoonInstancePostProcessorMock : NSObject <TyphoonInstancePostProcessor, TyphoonOrdered>

- (id)initWithOrder:(NSInteger)order;

@property(nonatomic, copy) PostProcessBlock postProcessBlock;

@end