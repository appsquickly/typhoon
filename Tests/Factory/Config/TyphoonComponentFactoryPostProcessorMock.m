//
//  TyphoonComponentFactoryPostProcessorMock.m
//  Tests
//
//  Created by Erik Sundin on 9/8/13.
//
//

#import "TyphoonComponentFactoryPostProcessorMock.h"

@implementation TyphoonComponentFactoryPostProcessorMock

-(void)postProcessComponentFactory:(TyphoonComponentFactory *)factory {
  self.postProcessingCalled = YES;
}

@end
