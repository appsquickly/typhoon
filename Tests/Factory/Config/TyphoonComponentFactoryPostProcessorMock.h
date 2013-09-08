//
//  TyphoonComponentFactoryPostProcessorMock.h
//  Tests
//
//  Created by Erik Sundin on 9/8/13.
//
//

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactoryPostProcessor.h"

@interface TyphoonComponentFactoryPostProcessorMock : NSObject<TyphoonComponentFactoryPostProcessor>

@property (nonatomic, assign) BOOL postProcessingCalled;

@end
