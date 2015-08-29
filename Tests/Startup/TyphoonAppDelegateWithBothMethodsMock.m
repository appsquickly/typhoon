//
//  TyphoonAppDelegateWithBothMethodsMock.m
//  Typhoon
//
//  Created by Egor Tolstoy on 30/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

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
