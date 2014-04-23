//
//  TyphoonInjectionContext.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 25.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionContext.h"

@implementation TyphoonInjectionContext

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionContext *copied = [[TyphoonInjectionContext allocWithZone:zone] init];
    copied.factory = self.factory;
    copied.args = self.args;
    copied.destinationType = self.destinationType;
    copied.destinationInstanceClass = self.destinationInstanceClass;
    copied.raiseExceptionIfCircular = self.raiseExceptionIfCircular;
    return copied;
}

@end
