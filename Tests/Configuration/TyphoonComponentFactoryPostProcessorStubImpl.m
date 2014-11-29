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

#import "TyphoonComponentFactoryPostProcessorStubImpl.h"
#import "TyphoonDefinition.h"

@implementation TyphoonComponentFactoryPostProcessorStubImpl

- (void)postProcessDefinition:(TyphoonDefinition *)definition replacement:(TyphoonDefinition **)definitionToReplace
{
    self.postProcessingCalled = YES;
}


@end
