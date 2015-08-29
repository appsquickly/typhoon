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

#import "TyphoonAppDelegateWithInitialFactoryMock.h"
#import "MiddleAgesAssembly.h"

@implementation TyphoonAppDelegateWithInitialFactoryMock

- (id)initialFactory
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly new];
    return [assembly activate];
}

@end
