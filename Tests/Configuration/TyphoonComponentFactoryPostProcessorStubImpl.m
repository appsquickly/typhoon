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

#import "TyphoonComponentFactoryPostProcessorStubImpl.h"

@implementation TyphoonComponentFactoryPostProcessorStubImpl

- (void)postProcessDefinitionsInFactory:(TyphoonComponentFactory *)factory
{
    self.postProcessingCalled = YES;
}

@end
