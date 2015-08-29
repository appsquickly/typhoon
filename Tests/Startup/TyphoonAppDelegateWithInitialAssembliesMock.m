//
//  TyphoonAppDelegateWithInitialAssembliesMock.m
//  Typhoon
//
//  Created by Egor Tolstoy on 30/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import "TyphoonAppDelegateWithInitialAssembliesMock.h"
#import "MiddleAgesAssembly.h"

@implementation TyphoonAppDelegateWithInitialAssembliesMock

- (NSArray *)initialAssemblies
{
    return @[
             [MiddleAgesAssembly class]
             ];
}

@end
