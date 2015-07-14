//
//  TyphoonTestRootClass.m
//  Typhoon
//
//  Created by Herman Saprykin on 15/07/15.
//  Copyright (c) 2015 typhoonframework.org. All rights reserved.
//

#import "ClassForNoSubclass.h"

@implementation ClassForNoSubclass

+ (BOOL)isSubclassOfClass:(Class)aClass{
    return NO;
}

@end
