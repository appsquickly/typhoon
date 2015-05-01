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
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"

@implementation TyphoonComponentFactoryPostProcessorStubImpl

- (void)postProcessDefinition:(TyphoonDefinition *)definition replacement:(TyphoonDefinition **)definitionToReplace withFactory:(TyphoonComponentFactory *)factory
{
    self.postProcessingCalled = YES;
}

@end
