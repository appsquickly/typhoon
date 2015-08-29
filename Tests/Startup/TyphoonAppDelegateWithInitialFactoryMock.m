//
//  TyphoonAppDelegateWithInitialFactoryMock.m
//  Typhoon
//
//  Created by Egor Tolstoy on 30/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import "TyphoonAppDelegateWithInitialFactoryMock.h"
#import "MiddleAgesAssembly.h"

@implementation TyphoonAppDelegateWithInitialFactoryMock

- (id)initialFactory
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly new];
    return [assembly activate];
}

@end
