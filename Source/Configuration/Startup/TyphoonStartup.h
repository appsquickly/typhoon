//
// Created by Aleksey Garbarev on 05.06.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TyphoonComponentFactory;


@interface TyphoonStartup : NSObject


+ (TyphoonComponentFactory *)initialFactory;

@end