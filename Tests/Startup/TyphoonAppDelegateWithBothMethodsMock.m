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

#import "TyphoonAppDelegateWithBothMethodsMock.h"
#import "MiddleAgesAssembly.h"
#import "SimpleAssembly.h"

@implementation TyphoonAppDelegateWithBothMethodsMock

- (id)initialFactory
{
    SimpleAssembly *assembly = [SimpleAssembly new];
    return [assembly activate];
}

- (NSArray *)initialAssemblies
{
    return @[
             [MiddleAgesAssembly class]
             ];
}

@end
